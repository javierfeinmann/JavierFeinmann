**********************************************************
Informacion sobre los archivos para la segunda extraccion.
**********************************************************

La extraccion contiene tres carpetas: Figures (graficos), scripts (codigos) y tabelas (.csv)

***CARPETA TABELAS

1) cursos_mas_de_10_graduados
Esta carpeta contiene 25 .csv que estan separados por anios (estan las cohorts de 2010 a 2015).
Para cada anio/cohort, hay un archivo para que grupo de variables: las asociadas a rais y entrepreneurship.
Las cohorts corresponden a los GRADUADOS en cada anio.

IMPORTANTE: EN TODOS LOS ARCHIVOS, CADA FILA REFIERE A UN CURSO. NO HAY NINGUN DATO A NIVEL INDIVDUO. TODOS LOS
RESULTADOS CON PROMEDIOS DEL CURSO Y SOLAMENTE EXTRAEMOS AQUELLOS CURSOS CON MAS DE 10 ESTUDIANTES CADA UNO.
SE PUEDE VERIFICAR UTILIZANDO LA VARIABLE "num_stud", LA CUAL INDICA CUANDO ESTUDIANTE CONFORMAN CADA CURSO.

2) cursos_mas_de_10_ingresantes
Esta carpeta contiene 25 .csv que estan separados por anios (estan las cohorts de 2010 a 2015).
Para cada anio/cohort, hay un archivo para que grupo de variables: las asociadas a rais y entrepreneurship.
Las cohorts corresponden a los INGRESANTES en cada anio. --> principal diferencia con (1)

IMPORTANTE: EN TODOS LOS ARCHIVOS, CADA FILA REFIERE A UN CURSO. NO HAY NINGUN DATO A NIVEL INDIVDUO. TODOS LOS
RESULTADOS CON PROMEDIOS DEL CURSO Y SOLAMENTE EXTRAEMOS AQUELLOS CURSOS CON MAS DE 10 ESTUDIANTES CADA UNO.
SE PUEDE VERIFICAR UTILIZANDO LA VARIABLE "num_stud", LA CUAL INDICA CUANDO ESTUDIANTE CONFORMAN CADA CURSO.

3) mobilidad_social_entrepreneurship

Esta carpeta contiene distintos .csv. Ningun archivo contiene informacion invidual, sino que usan criterios para agrupar:

Agrupacion por la nota the matematica que se sacaron (bins de 50 puntos): "variables_at_math_binnu_ano_nm.csv", "entrepreneurship_outcomes_mathbinnu_ano_nm_educ_group.csv" and "retake_enem_mathbin_pct_gdp_pc.csv"
Agrupacion por nivel socio-economico del hogar: "variables_at_pct_gdp_pcnu_ano_nm.csv" and "entrepreneurship_outcomes_pct_gdp_pcnu_ano_nm_educ_group.csv"
Agrupacion a nivel empresa (primeros 8 digitos del CNPJ): "entrepreneurship_networks1.csv" and "entrepreneurship_networks2.csv"
Agrupacion por COIES (solo mas de 10 individuos por coies): "chetty_replication_coies2.csv", "ranking_coies_graduates2010_2012.csv"
 


