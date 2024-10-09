################################## Graduates ###################################

rm(list=ls())

# Load necessary libraries
library(dplyr)
library(labelled)
library(haven)

# Set the working directory
setwd("D:/Dropbox/INEP_EXTRACCIONES/extractions/segunda_extraccion/database/Raw data/cursos_mas_de_10_graduados")

# Define the years to process
years_to_process <- c(2010, 2011, 2012, 2013, 2014, 2015)

# Loop through each year
for (yearloop in years_to_process) {
  
  # Load datasets for the current year with ; separator
  outcomes <- read.csv(paste0("graduates_", yearloop, "_outcomes_cocursolevel.csv"), sep=";")
  rais_2019 <- read.csv(paste0("graduates_", yearloop, "_rais2019_cocursolevel.csv"), sep=";")
  rais_2020 <- read.csv(paste0("graduates_", yearloop, "_rais2020_cocursolevel.csv"), sep=";")
  rais_2021 <- read.csv(paste0("graduates_", yearloop, "_rais2021_cocursolevel.csv"), sep=";")
  demographics_1 <- read.csv("graduates_demographics_cocursolevel1.csv", sep=";")
  demographics_2 <- read.csv("graduates_demographics_cocursolevel2.csv", sep=";")
  demographics_3 <- read.csv("graduates_demographics_cocursolevel3.csv", sep=";")
  
  # Combine all demographics datasets into one
  demographics_combined <- bind_rows(demographics_1, demographics_2, demographics_3)
  
  # Filter demographics data to only include the current year
  demographics_filtered <- demographics_combined %>% filter(year == yearloop)
  
  # Rename specific columns
  outcomes <- outcomes %>%
    rename(
      below_med_work_entrepreneur = below_med_work,
      below_med_wage_entrepreneur = below_med_wage,
      above_med_work_entrepreneur = above_med_work,
      above_med_wage_entrepreneur = above_med_wage,  
      cnae3_maxmode_entrepreneur = cnae3_maxmode,
      cnae3_minmode_entrepreneur = cnae3_minmode,
      cnae5_maxmode_entrepreneur = cnae5_maxmode,
      cnae5_minmode_entrepreneur = cnae5_minmode,
      av_wage_act_entrepreneur = av_wage_act,
      tot_workers_entrepreneur = tot_workers,
      setor_publico_entrepreneur = setor_publico,
      setor_privado_entrepreneur = setor_privado,
      setor_other_entrepreneur = setor_other,
      num_stud_entrepreneur = num_stud,
      tot_workers_curso_entrepreneur = tot_workers_curso,
      tot_wage_act_curso_entrepreneur = tot_wage_act_curso,
      av_workers_employer = av_workers,
      av_wages_act_employer = av_wages_act
    )
  
  rais_2019 <- rais_2019 %>%
    rename(
      inrais_employee = inrais,
      inrais_act_employee = inrais_act,
      wage_nozero_employee = wage_nozero,
      remdezr_employee = remdezr,
      remmedr_employee = remmedr,
      partime_employee = partime,
      setor_publico_employee = setor_publico,
      setor_privado_employee = setor_privado,
      setor_other_employee = setor_other,
      cnae5_minmode_employee = cnae5_minmode,
      cnae3_minmode_employee = cnae3_minmode,
      ocup4_minmode_employee = ocup4_minmode,
      ocup2_minmode_employee = ocup2_minmode,
      cnae5_maxmode_employee = cnae5_maxmode,
      cnae3_maxmode_employee = cnae3_maxmode,
      ocup4_maxmode_employee = ocup4_maxmode,
      ocup2_maxmode_employee = ocup2_maxmode
    )
  
  rais_2020 <- rais_2020 %>%
    rename(
      inrais_employee = inrais,
      inrais_act_employee = inrais_act,
      wage_nozero_employee = wage_nozero,
      remdezr_employee = remdezr,
      remmedr_employee = remmedr,
      partime_employee = partime,
      setor_publico_employee = setor_publico,
      setor_privado_employee = setor_privado,
      setor_other_employee = setor_other,
      cnae5_minmode_employee = cnae5_minmode,
      cnae3_minmode_employee = cnae3_minmode,
      ocup4_minmode_employee = ocup4_minmode,
      ocup2_minmode_employee = ocup2_minmode,
      cnae5_maxmode_employee = cnae5_maxmode,
      cnae3_maxmode_employee = cnae3_maxmode,
      ocup4_maxmode_employee = ocup4_maxmode,
      ocup2_maxmode_employee = ocup2_maxmode
    )
  
  rais_2021 <- rais_2021 %>%
    rename(
      inrais_employee = inrais,
      inrais_act_employee = inrais_act,
      wage_nozero_employee = wage_nozero,
      remdezr_employee = remdezr,
      remmedr_employee = remmedr,
      partime_employee = partime,
      setor_publico_employee = setor_publico,
      setor_privado_employee = setor_privado,
      setor_other_employee = setor_other,
      cnae5_minmode_employee = cnae5_minmode,
      cnae3_minmode_employee = cnae3_minmode,
      ocup4_minmode_employee = ocup4_minmode,
      ocup2_minmode_employee = ocup2_minmode,
      cnae5_maxmode_employee = cnae5_maxmode,
      cnae3_maxmode_employee = cnae3_maxmode,
      ocup4_maxmode_employee = ocup4_maxmode,
      ocup2_maxmode_employee = ocup2_maxmode
    )
  
   # Rename columns in RAIS datasets by adding the year suffix
  names(rais_2019) <- ifelse(names(rais_2019) %in% c("co_ies", "co_curso"),
                             names(rais_2019), paste0(names(rais_2019), "_2019"))
  
  names(rais_2020) <- ifelse(names(rais_2020) %in% c("co_ies", "co_curso"),
                             names(rais_2020), paste0(names(rais_2020), "_2020"))
  
  names(rais_2021) <- ifelse(names(rais_2021) %in% c("co_ies", "co_curso"),
                             names(rais_2021), paste0(names(rais_2021), "_2021"))
  
  # Sequentially merge the datasets using co_ies and co_curso as keys
  merged_data <- merge(outcomes, demographics_filtered, by = c("co_ies", "co_curso"))
  merged_data <- merge(merged_data, rais_2019, by = c("co_ies", "co_curso"), all = TRUE)
  merged_data <- merge(merged_data, rais_2020, by = c("co_ies", "co_curso"), all = TRUE)
  merged_data <- merge(merged_data, rais_2021, by = c("co_ies", "co_curso"), all = TRUE)
  
  # Apply labels to the merged dataset (this part is assumed to remain the same for each year)
  total_labels <- list(
    co_ies = "University identification code",
    co_curso = "Course code within the institution",
    num_stud = "Number of students in the course (Subtract -10 from the base)",
    pct_gdp_pc_master = "Average percentiles of the students neighborhoods' GDP per capita",
    nu_nota_mt_master = "Course average of the mathematics score in ENEM",
    fem_master = "Fraction of women",
    nonwhite_master = "Fraction of non-white students",
    father_college_master = "Fraction of students whose fathers attended college or higher education",
    mother_college_master = "Fraction of students whose mothers attended college or higher education",
    minwage_hh = "Fraction of students whose family earns the minimum wage or less",
    idade_master = "Average age of the students in the course",
    no_dem = "Fraction of the course with no demographic data",
    mis_highschool = "No information on the high school of origin",
    entrepreneur = "Fraction of students who are entrepreneurs",
    below_med_work_entrepreneur = "Fraction of entrepreneurs with firms employing below the national average",
    below_med_wage_entrepreneur = "Fraction of entrepreneurs with firms paying below the national average salary",
    above_med_work_entrepreneur = "Fraction of entrepreneurs with firms employing above the national average",
    above_med_wage_entrepreneur = "Fraction of entrepreneurs with firms paying above the national average salary",
    cnae3_maxmode_entrepreneur = "CNAE group's (3 digits) mode (max) of the course's entrepreneurships",
    cnae3_minmode_entrepreneur = "CNAE group's (3 digits) mode (min) of the course's entrepreneurships",
    cnae5_maxmode_entrepreneur = "CNAE class' (5 digits) mode (max) of the course's entrepreneurships",
    cnae5_minmode_entrepreneur = "CNAE class' (5 digits) mode (min) of the course's entrepreneurships",
    av_wage_act_entrepreneur = "Average wage of active employees in the firms entrepreneurs have opened",
    tot_workers_entrepreneur = "Average number of employees in the firms entrepreneurs have opened",
    setor_publico_entrepreneur = "Fraction of firms opened by entrepreneurs in the public sector",
    setor_privado_entrepreneur = "Fraction of firms opened by entrepreneurs in the private sector",
    setor_other_entrepreneur = "Fraction of firms opened by entrepreneurs in other sectors (e.g., NGOs)",
    tot_workers_curso_entrepreneur = "Total number of workers in the firms entrepreneurs have opened",
    tot_wage_act_curso_entrepreneur = "Total income of workers in the firms entrepreneurs have opened",
    open_mei = "Fraction of students who opened a MEI (Microempreendedor Individual)",
    pj_owner = "Fraction of students who are PJ (Persona Jurídica)",
    employer = "Fraction of the course who are employers",
    av_workers_employer = "Average number of employees working under the employers of the course",
    av_wages_act_employer = "Total income of employees working under the employers of the course",
    year = "year of the cohort's graduation",
    inrais_employee_2019 = "Fraction of students found in RAIS in 2019",
    inrais_act_employee_2019 = "Fraction of students with an active contract as of December 2019",
    wage_nozero_employee_2019 = "Average income conditional on receiving positive income in 2019",
    remdezr_employee_2019 = "December 2019 wage",
    remmedr_employee_2019 = "Average monthly wage in 2019",
    partime_employee_2019 = "Fraction of students working part-time in 2019",
    setor_publico_employee_2019 = "Fraction of students working in the public sector in 2019",
    setor_privado_employee_2019 = "Fraction of students working in the private sector in 2019",
    setor_other_employee_2019 = "Fraction of students working in other sectors (e.g., NGOs) in 2019",
    cnae5_minmode_employee_2019 = "CNAE class' (5 digits) mode (min) of the course's employees in 2019",
    cnae3_minmode_employee_2019 = "CNAE group's (3 digits) mode (min) of the course's employees in 2019",
    ocup4_minmode_employee_2019 = "Occupation code's (CBO, 4 digits) mode (min) of the course's employees in 2019",
    ocup2_minmode_employee_2019 = "Occupation code's (CBO, 2 digits) mode (min) of the course's employees in 2019",
    cnae5_maxmode_employee_2019 = "CNAE class' (5 digits) mode (max) of the course's employees in 2019",
    cnae3_maxmode_employee_2019 = "CNAE group's (3 digits) mode (max) of the course's employees in 2019",
    ocup4_maxmode_employee_2019 = "Occupation code's (CBO, 4 digits) mode (max) of the course's employees in 2019",
    ocup2_maxmode_employee_2019 = "Occupation code's (CBO, 2 digits) mode (max) of the course's employees in 2019",  
    tp_categoria_administrativa_2019 = "Type of academic organization by IES",
    tp_organizacao_academica_2019 = "Type of administrative category of the university by IES",
    tp_grau_academico_2019 = "Academic degree conferred by IES",
    tp_modalidade_ensino_2019 = "Type of teaching modality by IES",
    co_ocde_area_detalhada_2019 = "OCDE/UNESCO code of the course",
    inrais_employee_2020 = "Fraction of students found in RAIS in 2020",
    inrais_act_employee_2020 = "Fraction of students with an active contract as of December 2020",
    wage_nozero_employee_2020 = "Average income conditional on receiving positive income in 2020",
    remdezr_employee_2020 = "December 2020 wage",
    remmedr_employee_2020 = "Average monthly wage in 2020",
    partime_employee_2020 = "Fraction of students working part-time in 2020",
    setor_publico_employee_2020 = "Fraction of students working in the public sector in 2020",
    setor_privado_employee_2020 = "Fraction of students working in the private sector in 2020",
    setor_other_employee_2020 = "Fraction of students working in other sectors (e.g., NGOs) in 2020",
    cnae5_minmode_employee_2020 = "CNAE class' (5 digits) mode (min) of the course's employees in 2020",
    cnae3_minmode_employee_2020 = "CNAE group's (3 digits) mode (min) of the course's employees in 2020",
    ocup4_minmode_employee_2020 = "Occupation code's (CBO, 4 digits) mode (min) of the course's employees in 2020",
    ocup2_minmode_employee_2020 = "Occupation code's (CBO, 2 digits) mode (min) of the course's employees in 2020",
    cnae5_maxmode_employee_2020 = "CNAE class' (5 digits) mode (max) of the course's employees in 2020",
    cnae3_maxmode_employee_2020 = "CNAE group's (3 digits) mode (max) of the course's employees in 2020",
    ocup4_maxmode_employee_2020 = "Occupation code's (CBO, 4 digits) mode (max) of the course's employees in 2020",
    ocup2_maxmode_employee_2020 = "Occupation code's (CBO, 2 digits) mode (max) of the course's employees in 2020",  
    inrais_employee_2021 = "Fraction of students found in RAIS in 2021",
    inrais_act_employee_2021 = "Fraction of students with an active contract as of December 2021",
    wage_nozero_employee_2021 = "Average income conditional on receiving positive income in 2021",
    remdezr_employee_2021 = "December 2021 wage",
    remmedr_employee_2021 = "Average monthly wage in 2021",
    partime_employee_2021 = "Fraction of students working part-time in 2021",
    setor_publico_employee_2021 = "Fraction of students working in the public sector in 2021",
    setor_privado_employee_2021 = "Fraction of students working in the private sector in 2021",
    setor_other_employee_2021 = "Fraction of students working in other sectors (e.g., NGOs) in 2021",
    cnae5_minmode_employee_2021 = "CNAE class' (5 digits) mode (min) of the course's employees in 2021",
    cnae3_minmode_employee_2021 = "CNAE group's (3 digits) mode (min) of the course's employees in 2021",
    ocup4_minmode_employee_2021 = "Occupation code's (CBO, 4 digits) mode (min) of the course's employees in 2021",
    ocup2_minmode_employee_2021 = "Occupation code's (CBO, 2 digits) mode (min) of the course's employees in 2021",
    cnae5_maxmode_employee_2021 = "CNAE class' (5 digits) mode (max) of the course's employees in 2021",
    cnae3_maxmode_employee_2021 = "CNAE group's (3 digits) mode (max) of the course's employees in 2021",
    ocup4_maxmode_employee_2021 = "Occupation code's (CBO, 4 digits) mode (max) of the course's employees in 2021",
    ocup2_maxmode_employee_2021 = "Occupation code's (CBO, 2 digits) mode (max) of the course's employees in 2021" 
    
  )
  
  # Apply labels to the merged data
  for (var in names(total_labels)) {
    if (var %in% colnames(merged_data)) {
      var_label(merged_data[[var]]) <- total_labels[[var]]
    }
  }
  
  # Remove the unlabeled variables from the merged_data as they are repeating in the rais database, or are the number of students, which also is repeating.
  unlabeled_vars <- names(merged_data)[sapply(merged_data, function(x) is.null(var_label(x)))]
  merged_data <- merged_data %>% select(-all_of(unlabeled_vars))
  
  # Rename specific columns
  merged_data <- merged_data %>%
    rename(
      tp_categoria_administrativa = tp_categoria_administrativa_2019,
      tp_organizacao_academica = tp_organizacao_academica_2019,
      tp_grau_academico = tp_grau_academico_2019,
      tp_modalidade_ensino = tp_modalidade_ensino_2019,
      co_ocde_area_detalhada = co_ocde_area_detalhada_2019
    )
  
  
  #Convert variables to a factor with labels
  merged_data <- merged_data %>%
    mutate(tp_modalidade_ensino = factor(tp_modalidade_ensino, 
                                         levels = c(1, 2), 
                                         labels = c("In-person", "Distance Learning Course")))
  
  merged_data <- merged_data %>%
    mutate(tp_organizacao_academica = factor(tp_organizacao_academica, 
                                         levels = c(1, 2, 3, 4, 5), 
                                         labels = c("University", "University Center", "College", "Federal Institute of Education,Science and Technology", "Federal Center for Technological Education" )))

  merged_data <- merged_data %>%
    mutate(tp_categoria_administrativa = factor(tp_categoria_administrativa, 
                                                levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9), 
                                                labels = c("Federal Public", "State Public", "Municipal Public", "Private for-Profit", "Private non-Profit", "Private - Strictly Private", "Special", "Private Community", "Private Confessional" )))
  
  merged_data <- merged_data %>%
    mutate(tp_grau_academico = factor(tp_grau_academico, 
                                                levels = c(1, 2, 3, 4), 
                                                labels = c("Bachelor's Degree", "Teaching Degree (Licenciatura)", "Technological Degree", "Bachelor's and Teaching Degree (Licenciatura)")))
  
  
  # Save the final merged dataset in the specified path with the new name
  write.csv(merged_data, paste0("D:/Dropbox/INEP_EXTRACCIONES/extractions/segunda_extraccion/database/Clean data/Graduates/merged_graduates_", yearloop, ".csv"), row.names = FALSE)
  
  # Save the merged data as a .dta file while keeping the labels
  write_dta(merged_data, paste0("D:/Dropbox/INEP_EXTRACCIONES/extractions/segunda_extraccion/database/Clean data/Graduates/merged_graduates_", yearloop, ".dta"))
  
  # Print the progress
  print(paste("Processing completed for year:", yearloop))
}


############################## New Students ####################################

rm(list=ls())

# Load necessary libraries
library(dplyr)
library(labelled)
library(haven)

# Set the working directory
setwd("D:/Dropbox/INEP_EXTRACCIONES/extractions/segunda_extraccion/database/Raw data/cursos_mas_de_10_ingresantes")

# Define the years to process
years_to_process <- c(2010, 2011, 2012, 2013, 2014, 2015)

# Loop through each year
for (yearloop in years_to_process) {
  
  # Load datasets for the current year with ; separator
  outcomes <- read.csv(paste0("new_students_", yearloop, "_outcomes_cocursolevel.csv"), sep=";")
  rais_2019 <- read.csv(paste0("new_students_", yearloop, "_rais2019_cocursolevel.csv"), sep=";")
  rais_2020 <- read.csv(paste0("new_students_", yearloop, "_rais2020_cocursolevel.csv"), sep=";")
  rais_2021 <- read.csv(paste0("new_students_", yearloop, "_rais2021_cocursolevel.csv"), sep=";")
  demographics_1 <- read.csv("new_students_demographics_cocursolevel1.csv", sep=";")
  demographics_2 <- read.csv("new_students_demographics_cocursolevel2.csv", sep=";")
  demographics_3 <- read.csv("new_students_demographics_cocursolevel3.csv", sep=";")
  
  # Combine all demographics datasets into one
  demographics_combined <- bind_rows(demographics_1, demographics_2, demographics_3)
  
  # Filter demographics data to only include the current year
  demographics_filtered <- demographics_combined %>% filter(year == yearloop)
  
  # Rename specific columns
  outcomes <- outcomes %>%
    rename(
      below_med_work_entrepreneur = below_med_work,
      below_med_wage_entrepreneur = below_med_wage,
      above_med_work_entrepreneur = above_med_work,
      above_med_wage_entrepreneur = above_med_wage,  
      cnae3_maxmode_entrepreneur = cnae3_maxmode,
      cnae3_minmode_entrepreneur = cnae3_minmode,
      cnae5_maxmode_entrepreneur = cnae5_maxmode,
      cnae5_minmode_entrepreneur = cnae5_minmode,
      av_wage_act_entrepreneur = av_wage_act,
      tot_workers_entrepreneur = tot_workers,
      setor_publico_entrepreneur = setor_publico,
      setor_privado_entrepreneur = setor_privado,
      setor_other_entrepreneur = setor_other,
      num_stud_entrepreneur = num_stud,
      tot_workers_curso_entrepreneur = tot_workers_curso,
      tot_wage_act_curso_entrepreneur = tot_wage_act_curso,
      av_workers_employer = av_workers,
      av_wages_act_employer = av_wages_act
    )
  
  rais_2019 <- rais_2019 %>%
    rename(
      inrais_employee = inrais,
      inrais_act_employee = inrais_act,
      wage_nozero_employee = wage_nozero,
      remdezr_employee = remdezr,
      remmedr_employee = remmedr,
      partime_employee = partime,
      setor_publico_employee = setor_publico,
      setor_privado_employee = setor_privado,
      setor_other_employee = setor_other,
      cnae5_minmode_employee = cnae5_minmode,
      cnae3_minmode_employee = cnae3_minmode,
      ocup4_minmode_employee = ocup4_minmode,
      ocup2_minmode_employee = ocup2_minmode,
      cnae5_maxmode_employee = cnae5_maxmode,
      cnae3_maxmode_employee = cnae3_maxmode,
      ocup4_maxmode_employee = ocup4_maxmode,
      ocup2_maxmode_employee = ocup2_maxmode
    )
  
  rais_2020 <- rais_2020 %>%
    rename(
      inrais_employee = inrais,
      inrais_act_employee = inrais_act,
      wage_nozero_employee = wage_nozero,
      remdezr_employee = remdezr,
      remmedr_employee = remmedr,
      partime_employee = partime,
      setor_publico_employee = setor_publico,
      setor_privado_employee = setor_privado,
      setor_other_employee = setor_other,
      cnae5_minmode_employee = cnae5_minmode,
      cnae3_minmode_employee = cnae3_minmode,
      ocup4_minmode_employee = ocup4_minmode,
      ocup2_minmode_employee = ocup2_minmode,
      cnae5_maxmode_employee = cnae5_maxmode,
      cnae3_maxmode_employee = cnae3_maxmode,
      ocup4_maxmode_employee = ocup4_maxmode,
      ocup2_maxmode_employee = ocup2_maxmode
    )
  
  rais_2021 <- rais_2021 %>%
    rename(
      inrais_employee = inrais,
      inrais_act_employee = inrais_act,
      wage_nozero_employee = wage_nozero,
      remdezr_employee = remdezr,
      remmedr_employee = remmedr,
      partime_employee = partime,
      setor_publico_employee = setor_publico,
      setor_privado_employee = setor_privado,
      setor_other_employee = setor_other,
      cnae5_minmode_employee = cnae5_minmode,
      cnae3_minmode_employee = cnae3_minmode,
      ocup4_minmode_employee = ocup4_minmode,
      ocup2_minmode_employee = ocup2_minmode,
      cnae5_maxmode_employee = cnae5_maxmode,
      cnae3_maxmode_employee = cnae3_maxmode,
      ocup4_maxmode_employee = ocup4_maxmode,
      ocup2_maxmode_employee = ocup2_maxmode
    )
  
  # Rename columns in RAIS datasets by adding the year suffix
  names(rais_2019) <- ifelse(names(rais_2019) %in% c("co_ies", "co_curso"),
                             names(rais_2019), paste0(names(rais_2019), "_2019"))
  
  names(rais_2020) <- ifelse(names(rais_2020) %in% c("co_ies", "co_curso"),
                             names(rais_2020), paste0(names(rais_2020), "_2020"))
  
  names(rais_2021) <- ifelse(names(rais_2021) %in% c("co_ies", "co_curso"),
                             names(rais_2021), paste0(names(rais_2021), "_2021"))
  
  # Sequentially merge the datasets using co_ies and co_curso as keys
  merged_data <- merge(outcomes, demographics_filtered, by = c("co_ies", "co_curso"))
  merged_data <- merge(merged_data, rais_2019, by = c("co_ies", "co_curso"), all = TRUE)
  merged_data <- merge(merged_data, rais_2020, by = c("co_ies", "co_curso"), all = TRUE)
  merged_data <- merge(merged_data, rais_2021, by = c("co_ies", "co_curso"), all = TRUE)
  
  # Apply labels to the merged dataset (this part is assumed to remain the same for each year)
  total_labels <- list(
    co_ies = "Institution identification code",
    co_curso = "Course code within the institution",
    num_stud = "Number of students in the course (Subtract -10 from the base)",
    pct_gdp_pc_master = "Average percentiles of the neighborhoods where the students come from (GDP per capita)",
    nu_nota_mt_master = "Course average of the mathematics score in ENEM",
    fem_master = "Fraction of women",
    nonwhite_master = "Fraction of non-white students",
    father_college_master = "Fraction of students whose fathers attended college or higher education",
    mother_college_master = "Fraction of students whose mothers attended college or higher education",
    minwage_hh = "Fraction of students whose family earns the minimum wage or less",
    idade_master = "Average age of the students in the course",
    no_dem = "Fraction of the course with no demographic data",
    mis_highschool = "No information on the high school of origin",
    entrepreneur = "Fraction of students who are entrepreneurs",
    below_med_work_entrepreneur = "Fraction of entrepreneurs with firms employing below the national average",
    below_med_wage_entrepreneur = "Fraction of entrepreneurs with firms paying below the national average salary",
    above_med_work_entrepreneur = "Fraction of entrepreneurs with firms employing above the national average",
    above_med_wage_entrepreneur = "Fraction of entrepreneurs with firms paying above the national average salary",
    cnae3_maxmode_entrepreneur = "CNAE group's (3 digits) mode (max) of the course's entrepreneurships",
    cnae3_minmode_entrepreneur = "CNAE group's (3 digits) mode (min) of the course's entrepreneurships",
    cnae5_maxmode_entrepreneur = "CNAE class' (5 digits) mode (max) of the course's entrepreneurships",
    cnae5_minmode_entrepreneur = "CNAE class' (5 digits) mode (min) of the course's entrepreneurships",
    av_wage_act_entrepreneur = "Average wage of active employees in the firms entrepreneurs have opened",
    tot_workers_entrepreneur = "Average number of employees in the firms entrepreneurs have opened",
    setor_publico_entrepreneur = "Fraction of firms opened by entrepreneurs in the public sector",
    setor_privado_entrepreneur = "Fraction of firms opened by entrepreneurs in the private sector",
    setor_other_entrepreneur = "Fraction of firms opened by entrepreneurs in other sectors (e.g., NGOs)",
    tot_workers_curso_entrepreneur = "Total number of workers in the firms entrepreneurs have opened",
    tot_wage_act_curso_entrepreneur = "Total income of workers in the firms entrepreneurs have opened",
    open_mei = "Fraction of students who opened a MEI (Microempreendedor Individual)",
    pj_owner = "Fraction of students who are PJ (Persona Jurídica)",
    employer = "Fraction of the course who are employers",
    av_workers_employer = "Average number of employees working under the employers of the course",
    av_wages_act_employer = "Total income of employees working under the employers of the course",
    year = "Cohort's initial year",
    inrais_employee_2019 = "Fraction of students found in RAIS in 2019",
    inrais_act_employee_2019 = "Fraction of students with an active contract as of December 2019",
    wage_nozero_employee_2019 = "Average income conditional on receiving positive income in 2019",
    remdezr_employee_2019 = "December 2019 wage",
    remmedr_employee_2019 = "Average monthly wage in 2019",
    partime_employee_2019 = "Fraction of students working part-time in 2019",
    setor_publico_employee_2019 = "Fraction of students working in the public sector in 2019",
    setor_privado_employee_2019 = "Fraction of students working in the private sector in 2019",
    setor_other_employee_2019 = "Fraction of students working in other sectors (e.g., NGOs) in 2019",
    cnae5_minmode_employee_2019 = "CNAE class' (5 digits) mode (min) of the course's employees in 2019",
    cnae3_minmode_employee_2019 = "CNAE group's (3 digits) mode (min) of the course's employees in 2019",
    ocup4_minmode_employee_2019 = "Occupation code's (CBO, 4 digits) mode (min) of the course's employees in 2019",
    ocup2_minmode_employee_2019 = "Occupation code's (CBO, 2 digits) mode (min) of the course's employees in 2019",
    cnae5_maxmode_employee_2019 = "CNAE class' (5 digits) mode (max) of the course's employees in 2019",
    cnae3_maxmode_employee_2019 = "CNAE group's (3 digits) mode (max) of the course's employees in 2019",
    ocup4_maxmode_employee_2019 = "Occupation code's (CBO, 4 digits) mode (max) of the course's employees in 2019",
    ocup2_maxmode_employee_2019 = "Occupation code's (CBO, 2 digits) mode (max) of the course's employees in 2019",  
    tp_categoria_administrativa_2019 = "Type of academic organization by IES",
    tp_organizacao_academica_2019 = "Type of administrative category of the university by IES",
    tp_grau_academico_2019 = "Academic degree conferred by IES",
    tp_modalidade_ensino_2019 = "Type of teaching modality by IES",
    co_ocde_area_detalhada_2019 = "OCDE/UNESCO code of the course",
    inrais_employee_2020 = "Fraction of students found in RAIS in 2020",
    inrais_act_employee_2020 = "Fraction of students with an active contract as of December 2020",
    wage_nozero_employee_2020 = "Average income conditional on receiving positive income in 2020",
    remdezr_employee_2020 = "December 2020 wage",
    remmedr_employee_2020 = "Average monthly wage in 2020",
    partime_employee_2020 = "Fraction of students working part-time in 2020",
    setor_publico_employee_2020 = "Fraction of students working in the public sector in 2020",
    setor_privado_employee_2020 = "Fraction of students working in the private sector in 2020",
    setor_other_employee_2020 = "Fraction of students working in other sectors (e.g., NGOs) in 2020",
    cnae5_minmode_employee_2020 = "CNAE class' (5 digits) mode (min) of the course's employees in 2020",
    cnae3_minmode_employee_2020 = "CNAE group's (3 digits) mode (min) of the course's employees in 2020",
    ocup4_minmode_employee_2020 = "Occupation code's (CBO, 4 digits) mode (min) of the course's employees in 2020",
    ocup2_minmode_employee_2020 = "Occupation code's (CBO, 2 digits) mode (min) of the course's employees in 2020",
    cnae5_maxmode_employee_2020 = "CNAE class' (5 digits) mode (max) of the course's employees in 2020",
    cnae3_maxmode_employee_2020 = "CNAE group's (3 digits) mode (max) of the course's employees in 2020",
    ocup4_maxmode_employee_2020 = "Occupation code's (CBO, 4 digits) mode (max) of the course's employees in 2020",
    ocup2_maxmode_employee_2020 = "Occupation code's (CBO, 2 digits) mode (max) of the course's employees in 2020",  
    inrais_employee_2021 = "Fraction of students found in RAIS in 2021",
    inrais_act_employee_2021 = "Fraction of students with an active contract as of December 2021",
    wage_nozero_employee_2021 = "Average income conditional on receiving positive income in 2021",
    remdezr_employee_2021 = "December 2021 wage",
    remmedr_employee_2021 = "Average monthly wage in 2021",
    partime_employee_2021 = "Fraction of students working part-time in 2021",
    setor_publico_employee_2021 = "Fraction of students working in the public sector in 2021",
    setor_privado_employee_2021 = "Fraction of students working in the private sector in 2021",
    setor_other_employee_2021 = "Fraction of students working in other sectors (e.g., NGOs) in 2021",
    cnae5_minmode_employee_2021 = "CNAE class' (5 digits) mode (min) of the course's employees in 2021",
    cnae3_minmode_employee_2021 = "CNAE group's (3 digits) mode (min) of the course's employees in 2021",
    ocup4_minmode_employee_2021 = "Occupation code's (CBO, 4 digits) mode (min) of the course's employees in 2021",
    ocup2_minmode_employee_2021 = "Occupation code's (CBO, 2 digits) mode (min) of the course's employees in 2021",
    cnae5_maxmode_employee_2021 = "CNAE class' (5 digits) mode (max) of the course's employees in 2021",
    cnae3_maxmode_employee_2021 = "CNAE group's (3 digits) mode (max) of the course's employees in 2021",
    ocup4_maxmode_employee_2021 = "Occupation code's (CBO, 4 digits) mode (max) of the course's employees in 2021",
    ocup2_maxmode_employee_2021 = "Occupation code's (CBO, 2 digits) mode (max) of the course's employees in 2021" 
    
  )
  
  # Apply labels to the merged data
  for (var in names(total_labels)) {
    if (var %in% colnames(merged_data)) {
      var_label(merged_data[[var]]) <- total_labels[[var]]
    }
  }
  
  # Remove the unlabeled variables from the merged_data as they are repeating in the rais database, or are the number of students, which also is repeating.
  unlabeled_vars <- names(merged_data)[sapply(merged_data, function(x) is.null(var_label(x)))]
  merged_data <- merged_data %>% select(-all_of(unlabeled_vars))
  
  # Rename specific columns
  merged_data <- merged_data %>%
    rename(
      tp_categoria_administrativa = tp_categoria_administrativa_2019,
      tp_organizacao_academica = tp_organizacao_academica_2019,
      tp_grau_academico = tp_grau_academico_2019,
      tp_modalidade_ensino = tp_modalidade_ensino_2019,
      co_ocde_area_detalhada = co_ocde_area_detalhada_2019
    )
  
  #Convert variables to a factor with labels
  merged_data <- merged_data %>%
    mutate(tp_modalidade_ensino = factor(tp_modalidade_ensino, 
                                         levels = c(1, 2), 
                                         labels = c("In-person", "Distance Learning Course")))
  
  merged_data <- merged_data %>%
    mutate(tp_organizacao_academica = factor(tp_organizacao_academica, 
                                             levels = c(1, 2, 3, 4, 5), 
                                             labels = c("University", "University Center", "College", "Federal Institute of Education,Science and Technology", "Federal Center for Technological Education" )))
  
  merged_data <- merged_data %>%
    mutate(tp_categoria_administrativa = factor(tp_categoria_administrativa, 
                                                levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9), 
                                                labels = c("Federal Public", "State Public", "Municipal Public", "Private for-Profit", "Private non-Profit", "Private - Strictly Private", "Special", "Private Community", "Private Confessional" )))
  
  merged_data <- merged_data %>%
    mutate(tp_grau_academico = factor(tp_grau_academico, 
                                      levels = c(1, 2, 3, 4), 
                                      labels = c("Bachelor's Degree", "Teaching Degree (Licenciatura)", "Technological Degree", "Bachelor's and Teaching Degree (Licenciatura)")))
  
 
   # Save the final merged dataset in the specified path with the new name
  write.csv(merged_data, paste0("D:/Dropbox/INEP_EXTRACCIONES/extractions/segunda_extraccion/database/Clean data/New Students/merged_new_students_", yearloop, ".csv"), row.names = FALSE)
  
  # Save the merged data as a .dta file while keeping the labels
  write_dta(merged_data, paste0("D:/Dropbox/INEP_EXTRACCIONES/extractions/segunda_extraccion/database/Clean data/New Students/merged_new_students_", yearloop, ".dta"))
  
  # Print the progress
  print(paste("Processing completed for year:", yearloop))
}
