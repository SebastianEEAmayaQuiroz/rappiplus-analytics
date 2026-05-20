<div align="center">

<!-- BANNER PRINCIPAL -->
<a href="https://sebastianeeamayaquiroz.github.io/rappiplus-analytics/" target="_blank">
  <img src="https://img.shields.io/badge/🌐%20Ver%20Proyecto%20Completo%20en%20Web-%20Haz%20click%20aquí-FF441F?style=for-the-badge&labelColor=1a1a1a&color=FF441F" alt="Ver proyecto completo" />
</a>

<br/><br/>

<a href="https://app.powerbi.com/view?r=eyJrIjoiYzRkZDVlNjAtMGFiYS00MTM5LTlhNjItMTUzYTA3YzE2OWEyIiwidCI6ImY5NGJmNGQ5LTgwOTctNDc5NC1hZGY2LWE1NDY2Y2EyODU2MyIsImMiOjR9" target="_blank">
  <img src="https://img.shields.io/badge/Power%20BI-Ver%20Dashboard%20Interactivo-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI" />
</a>

<a href="https://colab.research.google.com/drive/1CqJnSo9DDa2bSrFENp9n3nbYllumZdVj?usp=sharing" target="_blank">
  <img src="https://img.shields.io/badge/Google%20Colab-Ver%20Notebook-F9AB00?style=for-the-badge&logo=googlecolab&logoColor=black" alt="Google Colab" />
</a>

<br/><br/>

<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
<img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white" />
<img src="https://img.shields.io/badge/SQL-PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white" />
<img src="https://img.shields.io/badge/SciPy-8CAAE6?style=for-the-badge&logo=scipy&logoColor=white" />
<img src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />

# 🛒 RappiPlus — De Datos a Decisiones de Negocio
### Proyecto Final · Análisis Integral de E-Commerce

**¿Es rentable? ¿Dónde se pierden usuarios? ¿Vuelven a comprar? ¿El nuevo checkout convierte mejor?**

</div>

---

## 📌 Contexto del negocio

RappiPlus opera en **México, Colombia y Argentina** con tres categorías: Electrónica, Moda y Hogar. Este proyecto final integra análisis de rentabilidad en Python, funnel de conversión SQL, retención por cohortes y prueba A/B estadística — respondiendo con datos las preguntas más críticas del negocio.

---

## 📊 KPIs principales

| Métrica | Valor |
|---|---|
| **Revenue Total** | $51,954,718.94 |
| **Total de Pedidos** | 24,916 |
| **Ticket Promedio** | $2,085.20 |
| **Gasto Marketing** | $2,871,843.53 |
| **Países activos** | México · Colombia · Argentina |

---

## 🔍 Análisis SCPR — Narrativa ejecutiva

### 💰 Hallazgo 1 — Rentabilidad del negocio

**Situación:** RappiPlus generó $51.9M en revenue con 24,916 pedidos distribuidos equitativamente entre México, Colombia y Argentina en el período analizado.

**Complicación:** El gasto en marketing alcanzó $2.87M. Sin conocer el profit neto real (revenue − costo − marketing) no es posible saber si el negocio es sostenible a largo plazo.

**Pregunta:** ¿El negocio genera profit positivo después de descontar costos de producto y marketing?

**Respuesta:** El análisis confirma que el negocio es **rentable**. El canal Organic resulta el más eficiente al no generar costo directo de adquisición. Las tres categorías son rentables con márgenes similares entre sí.

---

### 🛒 Hallazgo 2 — Funnel de conversión

**Situación:** Los usuarios recorren 5 etapas: `first_visit` → `product_view` → `add_to_cart` → `begin_checkout` → `purchase`.

**Complicación:** El mayor drop-off ocurre entre `add_to_cart` y `begin_checkout` — donde el usuario ya mostró intención de compra pero abandona antes de completarla.

**Pregunta:** ¿En qué etapa se pierde la mayor cantidad de usuarios y cuál es la tasa de conversión final?

**Respuesta:** Las funciones SQL `FIRST_VALUE` y `LAG` cuantifican cada drop-off. La tasa de conversión final (first_visit → purchase) identifica el punto de mayor fricción y orienta intervenciones de UX prioritarias.

---

### 🔁 Hallazgo 3 — Retención por cohortes

**Situación:** Usuarios agrupados por mes de registro. Se mide actividad en semanas 1, 2 y 3 post-registro.

**Complicación:** La retención cae semana a semana. Sin medición por cohorte es imposible saber si el negocio mejora o empeora su capacidad de retener usuarios con el tiempo.

**Pregunta:** ¿Qué cohortes tienen mayor retención y en qué semana se produce el mayor abandono?

**Respuesta:** La consulta SQL con CTEs calcula `semana_1`, `semana_2`, `semana_3` como % del total por cohorte. Identifica qué mes de adquisición generó los usuarios más fieles y cuándo se produce el mayor riesgo de abandono.

---

### 🧪 Hallazgo 4 — Test A/B en el checkout

**Situación:** Experimento con nueva UI en checkout. Hipótesis: mejora la tasa de conversión de compra.

**Complicación:** El grupo de tratamiento mostró una diferencia vs. el control, pero sin un test formal no se puede saber si es real o producto del azar.

**Pregunta:** ¿El cambio en la UI tiene un impacto estadísticamente significativo en la conversión?

**Respuesta:** T-test de dos muestras independientes con α = 0.05 → **p-valor > 0.05**. No se rechaza H₀. La diferencia observada no es estadísticamente significativa con los datos actuales. Se recomienda continuar el experimento con mayor volumen de datos.

---

## 🛠️ Stack técnico

| Herramienta | Uso |
|---|---|
| Python + Pandas | Limpieza de datos, KPIs, visualizaciones |
| SQL (PostgreSQL) | Funnel de conversión, retención por cohortes |
| SQLAlchemy | Conexión Python ↔ base de datos |
| SciPy | T-test estadístico para el experimento A/B |
| Power BI | Dashboard ejecutivo (Overview + Detalle) |
| Matplotlib | Visualizaciones de revenue y profit por categoría |

---

## 🗂️ Estructura del proyecto

```
rappiplus-analytics/
├── rappiplus_datos_limpios.xlsx              # Dataset limpio (3 hojas)
├── rappiplus_consultas_SQL.sql               # Consultas SQL documentadas
├── S12_Estudiante_Proyecto_Final.ipynb       # Notebook completo
├── index.html                                # Página web (GitHub Pages)
└── README.md
```

---

## 🚀 Acceder al proyecto

<div align="center">

[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard%20Interactivo-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://app.powerbi.com/view?r=eyJrIjoiYzRkZDVlNjAtMGFiYS00MTM5LTlhNjItMTUzYTA3YzE2OWEyIiwidCI6ImY5NGJmNGQ5LTgwOTctNDc5NC1hZGY2LWE1NDY2Y2EyODU2MyIsImMiOjR9)

[![Google Colab](https://img.shields.io/badge/Google%20Colab-Notebook%20Completo-F9AB00?style=for-the-badge&logo=googlecolab&logoColor=black)](https://colab.research.google.com/drive/1CqJnSo9DDa2bSrFENp9n3nbYllumZdVj?usp=sharing)

</div>

---

## 👤 Autor

**Sebastián Amaya** — Analista de Datos | Contador Público en formación

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sebastianamayada)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/SebastianEEAmayaQuiroz)

---

*Proyecto Final — Bootcamp de Análisis de Datos · TripleTen (2025–2026)*
