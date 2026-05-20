-- ================================================================
--  PROYECTO RAPPIPLUS — CONSULTAS SQL
--  Pasos 3 y 4: Funnel de conversión y Retención por cohortes
--
--  INSTRUCCIONES DE USO:
--  Estas consultas van integradas dentro del Jupyter Notebook
--  en las variables query_totals, query_conversion,
--  query_user_activity y query_cohort_retention_final.
--  Copia cada bloque SQL dentro de las triples comillas ''' '''
--  que ya existen en cada celda del notebook.
--
--  La conexión a la base de datos ya está configurada en el
--  notebook (celda de conexión con SQLAlchemy). NO la modifiques.
-- ================================================================


-- ================================================================
-- PASO 3 — FUNNEL DE CONVERSIÓN
-- Tabla fuente: events
-- ================================================================


-- ---------------------------------------------------------------
-- CONSULTA 1: Totales del funnel
-- Dónde va: variable `query_totals` en el notebook (Paso 3, Parte 1)
-- ---------------------------------------------------------------
SELECT
    nombre_evento,
    COUNT(DISTINCT id_usuario) AS usuarios_unicos
FROM events
GROUP BY nombre_evento
ORDER BY usuarios_unicos DESC;


-- ---------------------------------------------------------------
-- CONSULTA 2: Conversiones paso a paso
-- Dónde va: variable `query_conversion` en el notebook (Paso 3, Parte 2)
--
-- Lógica:
--   1. CTE 'funnel'         → cuenta usuarios únicos por evento
--   2. CTE 'ordered_funnel' → asigna número de orden al flujo
--                             first_visit → product_view → add_to_cart
--                             → begin_checkout → purchase
--   3. Query final          → calcula:
--        conversion_vs_inicio_pct    : % de usuarios que llegaron
--                                       a este paso vs. primer paso
--        conversion_paso_anterior_pct: % de usuarios que avanzaron
--                                       desde el paso anterior (drop-off)
-- ---------------------------------------------------------------
WITH funnel AS (
    SELECT
        nombre_evento,
        COUNT(DISTINCT id_usuario) AS usuarios_unicos
    FROM events
    GROUP BY nombre_evento
),
ordered_funnel AS (
    SELECT
        nombre_evento,
        usuarios_unicos,
        CASE nombre_evento
            WHEN 'first_visit'    THEN 1
            WHEN 'product_view'   THEN 2
            WHEN 'add_to_cart'    THEN 3
            WHEN 'begin_checkout' THEN 4
            WHEN 'purchase'       THEN 5
            ELSE 99
        END AS orden_funnel
    FROM funnel
)
SELECT
    nombre_evento,
    usuarios_unicos,
    ROUND(
        100.0 * usuarios_unicos
        / FIRST_VALUE(usuarios_unicos) OVER (ORDER BY orden_funnel),
        2
    ) AS conversion_vs_inicio_pct,
    ROUND(
        100.0 * usuarios_unicos
        / LAG(usuarios_unicos) OVER (ORDER BY orden_funnel),
        2
    ) AS conversion_paso_anterior_pct
FROM ordered_funnel
WHERE orden_funnel < 99
ORDER BY orden_funnel;


-- ================================================================
-- PASO 4 — RETENCIÓN POR COHORTES
-- Tablas fuente: users, user_activity
-- ================================================================


-- ---------------------------------------------------------------
-- CONSULTA 3: Explorar tabla user_activity
-- Dónde va: variable `query_user_activity` en el notebook (Paso 4)
-- ---------------------------------------------------------------
SELECT *
FROM user_activity
LIMIT 5;


-- ---------------------------------------------------------------
-- CONSULTA 4: Retención semanal por cohorte de registro
-- Dónde va: variable `query_cohort_retention_final` en el notebook (Paso 4)
--
-- Lógica:
--   1. CTE 'cohortes'  → une users con user_activity,
--                         agrupa usuarios por mes de registro
--   2. CTE 'resumen'   → cuenta usuarios activos (activo=1)
--                         en cada ventana semanal:
--                           W1: días 1-7  W2: días 8-14  W3: días 15-21
--   3. Query final     → calcula % de retención por semana
--                         dividiendo entre total_usuarios de la cohorte
--
-- Nota: CAST(fecha_registro AS DATE) garantiza el tipo correcto
--       NULLIF(total_usuarios,0) evita división entre cero
-- ---------------------------------------------------------------
WITH cohortes AS (
    SELECT
        u.id_usuario,
        TO_CHAR(CAST(u.fecha_registro AS DATE), 'YYYY-MM') AS cohorte,
        ua.dias_despues_registro,
        ua.activo
    FROM users u
    LEFT JOIN user_activity ua
        ON u.id_usuario = ua.id_usuario
),
resumen AS (
    SELECT
        cohorte,
        COUNT(DISTINCT id_usuario) AS total_usuarios,
        COUNT(DISTINCT CASE
            WHEN dias_despues_registro BETWEEN 1  AND 7  AND activo = 1
            THEN id_usuario END) AS retenido_w1,
        COUNT(DISTINCT CASE
            WHEN dias_despues_registro BETWEEN 8  AND 14 AND activo = 1
            THEN id_usuario END) AS retenido_w2,
        COUNT(DISTINCT CASE
            WHEN dias_despues_registro BETWEEN 15 AND 21 AND activo = 1
            THEN id_usuario END) AS retenido_w3
    FROM cohortes
    GROUP BY cohorte
)
SELECT
    cohorte,
    total_usuarios,
    retenido_w1,
    retenido_w2,
    retenido_w3,
    ROUND(100.0 * retenido_w1 / NULLIF(total_usuarios, 0), 1) AS semana_1,
    ROUND(100.0 * retenido_w2 / NULLIF(total_usuarios, 0), 1) AS semana_2,
    ROUND(100.0 * retenido_w3 / NULLIF(total_usuarios, 0), 1) AS semana_3
FROM resumen
ORDER BY cohorte;
