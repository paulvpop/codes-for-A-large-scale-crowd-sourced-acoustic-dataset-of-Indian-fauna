-------------------
## Chloropleth ####
-------------------
  
# R script for producing the data for figure 1
  
----------------------------
###### Getting started #####
----------------------------
  
# Set the working directory
setwd("~/Bioacoustics dataset paper/figures") # Replace with your working directory path

#Load in the necessary library sf
library(sf)

# Load in a shapefile with all the state and union territory boundaries whose 
# geometry issues have been already fixed

shapefile <- st_read("./shapefile_fixed/shapefile_valid.shp")   
# Reading layer `shapefile_valid' from data source 
#   `home/Bioacoustics dataset paper/figures/shapefile_fixed/shapefile_valid.shp' 
# using driver `ESRI Shapefile'
# Simple feature collection with 36 features and 1 field
# Geometry type: MULTIPOLYGON
# Dimension:     XY
# Bounding box:  xmin: 68.18625 ymin: 6.755953 xmax: 97.41529 ymax: 37.07827
# Geodetic CRS:  WGS 84
# View the shapefile
plot(shapefile[1])

#Load in the necessary libraries
library(dplyr)

----------------------
#### Data preparation for Type A  #####
----------------------
  
# Read in the type A metadata csv:
type_a <- read.csv("typea_meta_Jan31.csv")
# Check the structure
str(type_a)
# 'data.frame':	2287 obs. of  21 variables:
#   $ id                      : chr  "00098e68-94a4-4490-9bf1-4dfae7375b09" "0041cc46-6eab-4b23-a9b8-e6ddb8de4ae8" "00735c96-188f-48ba-882d-ada2a4c035bc" "0080895f-ee1d-4ac8-8702-da702ece1d1b" ...
# $ media_file_name         : chr  "ZOOM0201_lesser whitethroat.wav" "20250715_152900.WAV" "BKM_002_20250510_182500.WAV" "KN_002_20240320_183000.WAV" ...
# $ latitude                : num  32 24.2 11.5 11.6 13.2 ...
# $ longitude               : num  78.1 87.3 76.8 77.3 75.1 ...
# $ recording_date          : chr  "2025-05-19 AD" "2025-07-15 AD" "2025-05-10 AD" "2024-03-20 AD" ...
# $ authors                 : chr  "Mohammad Abdus Shakur" "Darukaa.Earth, Komal Meena" "Vandana Kannan, Mounthees K" "Vandana Kannan, Mathesan R, Vijay Ramesh" ...
# $ annotation_file_attached: chr  "True" "True" "True" "True" ...
# $ hide_exact_location     : chr  "False" "True" "True" "False" ...
# $ recording_type          : chr  "" "" "" "" ...
# $ notes                   : chr  "" "-" "" "" ...
# $ annotation_found        : chr  "True" "True" "True" "True" ...
# $ media_length_sec        : num  44 30 240 240 60 ...
# $ bit_depth               : num  32 16 16 16 16 16 16 16 16 16 ...
# $ sampling_rate           : num  44100 48000 48000 32000 48000 48000 48000 32000 16000 48000 ...
# $ byte_size               : num  15528154 2880750 23040786 15360488 5760488 ...
# $ binary_hash             : chr  "762106146bb57d8d82696a2dd339662a8e9a4f67787861556d303e251a10c6ba" "922b29df37d7f751837060a3a260d7068a0574fe6263d878af803e271e2cd1b0" "36aa173c2db39fd3c11003a019a16d9bd40f2fc0c4871bd5d4649be6e9e16ac2" "51198a2e9ccb6c2d384897441a52d252602d927e93b980fff99ca19c2fad6416" ...
# $ original_zip            : chr  "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section A data ("| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section A data ("| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section A data ("| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section A data ("| __truncated__ ...
# $ new_media_path          : chr  "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_media/Mohammad_Abdus_Shakur_1a10c6ba_ZOOM0201_less"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_media/Darukaa.Earth,_Komal_Meena_1e2cd1b0_20250715_152900.WAV" "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_media/Vandana_Kannan,_Mounthees_K_e9e16ac2_BKM_002"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_media/Vandana_Kannan,_Mathesan_R,_Vijay_Ramesh_2fa"| __truncated__ ...
# $ new_xls_path            : chr  "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_xls/Shakur_set6 - Abdus Shakur_meta_annotation_tem"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_xls/Darukaa_Dataset_TypeA_60min+ - Gaurav Singh_Me"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_xls/Bikkapathy mund - Vandana Kannan_meta_annotati"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeA_processed_xls/Melseemai - Vandana Kannan_meta_annotation_tem"| __truncated__ ...
# $ state                   : chr  "Himachal Pradesh" "Jharkhand" "Tamil Nadu" "Tamil Nadu" ...
# $ eco_name                : chr  "Northwestern Himalayan alpine shrub and meadows" "Chhota-Nagpur dry deciduous forests" "South Western Ghats montane rain forests" "South Western Ghats moist deciduous forests" ...

# Select necessary columns
type_a <- type_a %>% select(c("media_file_name", "binary_hash", "latitude","longitude","recording_date",
                              "media_length_sec", "state", "eco_name"))

#Check if the number of the media_file_name is the same as the number of binary_hash 
#(should be same)
length(unique(type_a$media_file_name))
#[1] 2287
length(unique(type_a$binary_hash))
#[1] 2278
#Since they are not the same, binary_hash can be used for deduplication

# You can save this data if you want:
write.csv(type_a, "type_a.csv")

# Check the statewise distribution of recordings for type A:
table(type_a$state)
# Andaman and Nicobar      Andhra Pradesh   Arunachal Pradesh               Assam 
#                   8                  60                  12                  22 
# Bihar               Delhi                 Goa             Gujarat 
#    12                   1                  11                   5 
# Haryana    Himachal Pradesh   Jammu and Kashmir           Jharkhand 
#       2                 206                  11                 132 
# Karnataka              Kerala      Madhya Pradesh         Maharashtra 
#       344                 168                 584                 403 
# Nagaland              Punjab          Tamil Nadu         Uttarakhand 
#        2                   2                 192                 104 
# West Bengal 
# 6 

# Convert type_a to an sf object (points)
type_a_sf <- st_as_sf(type_a, 
                      coords = c("longitude", "latitude"),
                      crs = 4326)  # WGS84 coordinate system

# Make sure shapefile has the same CRS (coordinate reference system)
if (st_crs(shapefile) != st_crs(type_a_sf)) {
  shapefile_valid <- st_transform(shapefile, st_crs(type_a_sf))
}

# Check if there are points outside any state (NA values)
missing_points <- sum(is.na(type_a_sf$state) | type_a_sf$state == "")
if (missing_points > 0) {
  message(paste(missing_points, "points are not within any state polygon"))
}

# Replace the name "Andaman and Nicobar" with "Andaman & Nicobar Islands" and
# "Jammu and Kashmir" with "Jammu & Kashmir" to save space in the figure
# in the state column. Also rename "Delhi" to "NCT of Delhi".
type_a_sf$state[type_a_sf$state == "Andaman and Nicobar"] <- "Andaman & Nicobar Islands"
type_a_sf$state[type_a_sf$state == "Jammu and Kashmir"] <- "Jammu & Kashmir"
type_a_sf$state[type_a_sf$state == "Delhi"] <- "NCT of Delhi"

# The duplicate files need to be removed to extract the correct recording duration.
# Since the binary_hash is a 64 character hexadecimal string, the distinct operation
# from dplyr will take time. Use data table for this operation instead and then 
# convert it back to an sf object.
library(data.table)

# Convert to data.table (temporary)
type_a_dt <- as.data.table(type_a_sf)
# Deduplicate using binary_hash
type_a_sf_unique <- type_a_dt[, .SD[1], by = binary_hash] %>% st_as_sf()

# Total minutes of recordings in Type A data:
(sum(type_a_sf_unique$media_length_sec))/60
#[1] 3406.195

# Summarize media_length_sec by state
result_a <- type_a_sf_unique %>%
  as.data.frame() %>%  # Convert back to dataframe for faster aggregation
  group_by(state) %>%
  summarise(total_media_length_sec = sum(media_length_sec, na.rm = TRUE)) %>%
  arrange(desc(total_media_length_sec))

# View the result
print(result_a)
# # A tibble: 21 × 2
# state                     total_media_length_sec
# <chr>                                      <dbl>
#   1 Kerala                                    59712.
# 2 Karnataka                                 35013.
# 3 Tamil Nadu                                32806.
# 4 Maharashtra                               19622.
# 5 Uttarakhand                               13557.
# 6 Madhya Pradesh                            10134.
# 7 Assam                                      8880.
# 8 Himachal Pradesh                           8844.
# 9 Jharkhand                                  3952 
# 10 Andaman & Nicobar Islands                  3796.
# # ℹ 11 more rows
# # ℹ Use `print(n = ...)` to see more rows

#Add columns for time in hours (to 2 decimals) and minutes, with both minutes and 
# and seconds rounded to remove decimals
result_a <- result_a %>% mutate(total_media_length_min = ceiling(total_media_length_sec/60),
                                #Using ceiling above to include data which is less than 1
                                # which will be rounded to 1 minute
                                total_media_length_hr = round(total_media_length_sec/3600,2),
                                total_media_length_sec = round(total_media_length_sec, 0))

#Add the names of the states not in the result from the shapefile_valid$ST_NM

#First fix a typo in the India shapefile:
shapefile$ST_NM[shapefile$ST_NM == "Arunanchal Pradesh"] <- "Arunachal Pradesh"

# Get the exact order of states from shapefile_valid
state <- unique(shapefile$ST_NM)

# Create a data frame with states in the correct order
all_states <- data.frame(state)

# Full join to include all states (including the ones without any recordings)
result_complete_a <- all_states %>%
  # Add all the states/UTs
  full_join(result_a, by = "state") %>%
  # Replace NA with 0 for the media length columns
  mutate(
    total_media_length_sec = ifelse(is.na(total_media_length_sec), 0, total_media_length_sec),
    total_media_length_min = ifelse(is.na(total_media_length_min), 0, total_media_length_min),
    total_media_length_hr = ifelse(is.na(total_media_length_hr), 0, total_media_length_hr)
  )

# View the result
print(result_complete_a)

# Save it as a csv if you want after sorting by recording duration/media length
res_a <- result_complete_a %>%
  arrange(desc(total_media_length_sec))  # Optional: sort by media length

write.csv(res_a, "type_a_summary.csv")
rm(res_a)

# Now it needs to be saved as a dbf to be used as a shapefile
# install.packages("foreign")
library(foreign)

# Create a version with appropriate column names (10 chars max due to dbf format
# limitations)
colnames(result_complete_a) <- c("ST_NM", "TOT_SEC", "TOT_MIN", "TOT_HR")

write.dbf(result_complete_a, "type_a.dbf")

# Now make a copy of the valid_shapefile
# Put it in a seperate folder for type a shapefile
# Replace the .dbf with the one downloaded 
# Rename all the other file types (.shp, .shx, etc) with the name of the .dbf (type_a)
# Now, it is ready to be used for creating a chloropleth in QGIS

--------------------
#### Data preparation for Type B ####
--------------------

# Load the Type B data
type_b <- read.csv("typeb_meta_Jan31.csv") 

# Check structure
str(type_b)
#'data.frame':	27455 obs. of  22 variables:
# $ id                 : chr  "0003ba40-8a54-4a90-9816-a83cf2e9b375" "00051fcb-bb86-4d64-8a01-f591f5904531" "00067fb9-b6e0-456b-8709-5321490561b2" "00072558-6af6-42b4-a08f-7274180cddea" ...
# $ media_file_name    : chr  "MG_FD_SD44_20200219_075000-3" "MG_FD_SD44_20200223_074000-1" "BK_SD05_20200212_062000-4" "BT_FD_SD56_20200223_063500-1" ...
# $ latitude           : num  22.3 22.3 22.4 22.4 22.3 ...
# $ longitude          : num  80.5 80.5 80.7 80.5 80.5 ...
# $ recording_date     : chr  "2020-02-19 AD" "2020-02-23 AD" "2020-02-12 AD" "2020-02-23 AD" ...
# $ authors            : chr  "Pooja Choksi, Siddharth Biniwale, Pravar Mourya " "Pooja Choksi, Siddharth Biniwale, Pravar Mourya " "Pooja Choksi, Siddharth Biniwale, Pravar Mourya" "Pooja Choksi, Siddharth Biniwale, Pravar Mourya " ...
# $ sci_name           : chr  "Anthus trivialis" "Phylloscopus trochiloides" "Psittacula cyanocephala" "Phylloscopus trochiloides" ...
# $ organism_seen      : chr  "" "" "" "" ...
# $ hide_exact_location: chr  "True" "True" "True" "True" ...
# $ recording_type     : chr  "" "" "" "" ...
# $ notes              : chr  "0" "0" "0" "" ...
# $ media_length_sec   : num  10 10 10 10 10 10 10 10 10 10 ...
# $ bit_depth          : num  16 16 16 16 16 16 16 16 16 16 ...
# $ sampling_rate      : num  48000 48000 48000 48000 48000 48000 48000 48000 48000 48000 ...
# $ byte_size          : num  960044 960044 960044 960044 960044 ...
# $ binary_hash        : chr  "e66f9f5c57184dff9afeb95a4068c4ca1be0e8028f49309e35482aa5fab4f526" "a9477b08c7f10dab1920f90fd5b03602aa8689f0c43ca73a15728f012c21abc0" "2e53d4e25bc9c9ad1eebbc15076a2e55a53cdf4c09679dd09722b970b30b6cb2" "e56124a7155b68183ca0cd04dfc0c6d06a8fec088b5474e60161d5075b00de0b" ...
# $ original_zip       : chr  "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section B data ("| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section B data ("| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section B data ("| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/Acoustic Data Upload Form (File responses)/Upload Section B data ("| __truncated__ ...
# $ new_media_path     : chr  "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_media/Pooja_Choksi,_Siddharth_Biniwale,_Pravar_Mou"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_media/Pooja_Choksi,_Siddharth_Biniwale,_Pravar_Mou"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_media/Pooja_Choksi,_Siddharth_Biniwale,_Pravar_Mou"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_media/Pooja_Choksi,_Siddharth_Biniwale,_Pravar_Mou"| __truncated__ ...
# $ new_xls_path       : chr  "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_xls/Manegaon-Zipped - Pooja Choksi_createdbysameer"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_xls/Manegaon-Zipped - Pooja Choksi_createdbysameer"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_xls/Bhanpur-Kheda-Zipped - Pooja Choksi_createdbys"| __truncated__ "/content/drive/MyDrive/IEN Acoustics Dataset/typeB_processed_xls/Batwar-FD-2-Zipped - Pooja Choksi_createdbysam"| __truncated__ ...
# $ state              : chr  "Madhya Pradesh" "Madhya Pradesh" "Madhya Pradesh" "Madhya Pradesh" ...
# $ taxa_info          : chr  "{\"rank\": \"SPECIES\", \"class\": \"Aves\", \"genus\": \"Anthus\", \"order\": \"Passeriformes\", \"family\": \"| __truncated__ "{\"rank\": \"SPECIES\", \"class\": \"Aves\", \"genus\": \"Phylloscopus\", \"order\": \"Passeriformes\", \"famil"| __truncated__ "{\"rank\": \"SPECIES\", \"class\": \"Aves\", \"genus\": \"Psittacula\", \"order\": \"Psittaciformes\", \"family"| __truncated__ "{\"rank\": \"SPECIES\", \"class\": \"Aves\", \"genus\": \"Phylloscopus\", \"order\": \"Passeriformes\", \"famil"| __truncated__ ...
# $ eco_name           : chr  "East Deccan moist deciduous forests" "East Deccan moist deciduous forests" "East Deccan moist deciduous forests" "East Deccan moist deciduous forests" ...

# Select the relevant columns
type_b <- type_b %>% select(c("media_file_name", "binary_hash", "latitude","longitude",
                              "recording_date","sci_name","media_length_sec",
                              "taxa_info","state","eco_name"))

# Check if the media_file_name is unique compared to the binary_hash
length(unique(type_b$media_file_name))
#[1] 10073
length(unique(type_b$binary_hash))
#[1] 9755

# They are not. So, use the binary_hash as it is unique

# They are
# Load the necessary libraries
library(jsonlite)

# Parse the JSON strings (this would likely take a many seconds)
parsed_data <- lapply(type_b$taxa_info, fromJSON)

# Convert to dataframe and bind to original (this would likely take a few seconds)
df_parsed_b <- bind_rows(parsed_data)

# Remove 'parsed_data' as it is a huge object
rm(parsed_data)

# Check the structure
str(df_parsed_b)
# tibble [27,455 × 22] (S3: tbl_df/tbl/data.frame)
# $ rank             : chr [1:27455] "SPECIES" "SPECIES" "SPECIES" "SPECIES" ...
# $ class            : chr [1:27455] "Aves" "Aves" "Aves" "Aves" ...
# $ genus            : chr [1:27455] "Anthus" "Phylloscopus" "Psittacula" "Phylloscopus" ...
# $ order            : chr [1:27455] "Passeriformes" "Passeriformes" "Psittaciformes" "Passeriformes" ...
# $ family           : chr [1:27455] "Motacillidae" "Phylloscopidae" "Psittacidae" "Phylloscopidae" ...
# $ phylum           : chr [1:27455] "Chordata" "Chordata" "Chordata" "Chordata" ...
# $ status           : chr [1:27455] "ACCEPTED" "ACCEPTED" "ACCEPTED" "ACCEPTED" ...
# $ kingdom          : chr [1:27455] "Animalia" "Animalia" "Animalia" "Animalia" ...
# $ classKey         : int [1:27455] 212 212 212 212 212 212 212 212 212 212 ...
# $ genusKey         : int [1:27455] 2490241 2493047 2479192 2493047 2493047 2479192 2493960 2493023 3241500 2479192 ...
# $ orderKey         : int [1:27455] 729 729 1445 729 729 1445 729 729 729 1445 ...
# $ usageKey         : int [1:27455] 2490246 2493084 5229044 2493084 2493084 5229044 2493970 2493028 7340855 5229044 ...
# $ familyKey        : int [1:27455] 5257 6100963 9340 6100963 6100963 9340 9310 9293 5259 9340 ...
# $ matchType        : chr [1:27455] "EXACT" "EXACT" "EXACT" "EXACT" ...
# $ phylumKey        : int [1:27455] 44 44 44 44 44 44 44 44 44 44 ...
# $ confidence       : int [1:27455] 99 99 99 99 99 99 99 99 99 99 ...
# $ kingdomKey       : int [1:27455] 1 1 1 1 1 1 1 1 1 1 ...
# $ speciesKey       : int [1:27455] 2490246 2493084 5229044 2493084 2493084 5229044 2493970 2493028 7340855 5229044 ...
# $ canonicalName    : chr [1:27455] "Anthus trivialis" "Phylloscopus trochiloides" "Psittacula cyanocephala" "Phylloscopus trochiloides" ...
# $ scientificName   : chr [1:27455] "Anthus trivialis (Linnaeus, 1758)" "Phylloscopus trochiloides (Sundevall, 1837)" "Psittacula cyanocephala (Linnaeus, 1766)" "Phylloscopus trochiloides (Sundevall, 1837)" ...
# $ submitted_sciname: chr [1:27455] NA NA NA NA ...
# $ acceptedUsageKey : int [1:27455] NA NA NA NA NA NA NA NA NA NA ...

# Combine selected columns with the original dataframe (excluding the original
# taxa_info column)
type_b <- cbind(type_b %>% select(-taxa_info), df_parsed_b %>% 
                  select(c(rank, kingdom, phylum, class, order, family, genus, speciesKey)))
#Save file
write.csv(type_b, "type_b.csv")

# Convert type_b to an sf object (points)
type_b_sf <- st_as_sf(type_b, 
                      coords = c("longitude", "latitude"),
                      crs = 4326, # WGS84 coordinate system
                      remove = FALSE)  # To prevent the removal of the latitude
                                       # and longitude columns which will be
                                       # needed later

# Check if there are points outside any state (NA or empty values). 
missing_points <- sum(is.na(type_b_sf$state) | type_b_sf$state == "")
if (missing_points > 0) {
  message(paste(missing_points, "points are not within any state polygon"))
}
# 2 points are not within any state polygon
# These are two recordings with no coordinate or state information. Nothing can
# be done about them.

# View a few rows of the object
head(type_b_sf)
# Simple feature collection with 6 features and 17 fields
# Geometry type: POINT
# Dimension:     XY
# Bounding box:  xmin: 80.4683 ymin: 22.30159 xmax: 80.66986 ymax: 22.43173
# Geodetic CRS:  WGS 84
# media_file_name                                                      binary_hash latitude
# 1  MG_FD_SD44_20200219_075000-3 e66f9f5c57184dff9afeb95a4068c4ca1be0e8028f49309e35482aa5fab4f526 22.30159
# 2  MG_FD_SD44_20200223_074000-1 a9477b08c7f10dab1920f90fd5b03602aa8689f0c43ca73a15728f012c21abc0 22.30159
# 3     BK_SD05_20200212_062000-4 2e53d4e25bc9c9ad1eebbc15076a2e55a53cdf4c09679dd09722b970b30b6cb2 22.43173
# 4  BT_FD_SD56_20200223_063500-1 e56124a7155b68183ca0cd04dfc0c6d06a8fec088b5474e60161d5075b00de0b 22.37523
# 5 MG_FD3_SD16_20201217_083000-4 14cd6ebb17ba14b3c3d998fd0fe5b0d992a900693694cb4ffe96e703bf5ffd16 22.30159
# 6     KW_SD27_20200223_093000-4 00e0968706cce78b86c3ab5e8435c65e6d59b3cbb9942c0967b528539d5b8a35 22.34773
# longitude recording_date                  sci_name media_length_sec          state
# 1  80.48631  2020-02-19 AD          Anthus trivialis               10 Madhya Pradesh
# 2  80.48631  2020-02-23 AD Phylloscopus trochiloides               10 Madhya Pradesh
# 3  80.66986  2020-02-12 AD   Psittacula cyanocephala               10 Madhya Pradesh
# 4  80.49737  2020-02-23 AD Phylloscopus trochiloides               10 Madhya Pradesh
# 5  80.48631  2020-12-17 AD Phylloscopus trochiloides               10 Madhya Pradesh
# 6  80.46830  2020-02-23 AD   Psittacula cyanocephala               10 Madhya Pradesh
# eco_name    rank  kingdom   phylum class          order         family
# 1 East Deccan moist deciduous forests SPECIES Animalia Chordata  Aves  Passeriformes   Motacillidae
# 2 East Deccan moist deciduous forests SPECIES Animalia Chordata  Aves  Passeriformes Phylloscopidae
# 3 East Deccan moist deciduous forests SPECIES Animalia Chordata  Aves Psittaciformes    Psittacidae
# 4 East Deccan moist deciduous forests SPECIES Animalia Chordata  Aves  Passeriformes Phylloscopidae
# 5 East Deccan moist deciduous forests SPECIES Animalia Chordata  Aves  Passeriformes Phylloscopidae
# 6 East Deccan moist deciduous forests SPECIES Animalia Chordata  Aves Psittaciformes    Psittacidae
# genus speciesKey                  geometry
# 1       Anthus    2490246 POINT (80.48631 22.30159)
# 2 Phylloscopus    2493084 POINT (80.48631 22.30159)
# 3   Psittacula    5229044 POINT (80.66986 22.43173)
# 4 Phylloscopus    2493084 POINT (80.49737 22.37523)
# 5 Phylloscopus    2493084 POINT (80.48631 22.30159)
# 6   Psittacula    5229044  POINT (80.4683 22.34773)

# Replace the name "Andaman and Nicobar" with "Andaman & Nicobar Islands" and
# "Jammu and Kashmir" with "Jammu & Kashmir" to save space in the figure
# in the state column. Also rename "Delhi" to "NCT of Delhi".
type_b_sf$state[type_b_sf$state == "Andaman and Nicobar"] <- "Andaman & Nicobar Islands"
type_b_sf$state[type_b_sf$state == "Jammu and Kashmir"] <- "Jammu & Kashmir"
type_b_sf$state[type_b_sf$state == "Delhi"] <- "NCT of Delhi"

# The duplicate files need to be removed to extract the correct recording duration.
# Since the binary_hash is a 64 character hexadecimal string, the distinct operation
# from dplyr will take time. Use data table for this operation instead and then 
# convert it back to an sf object.
library(data.table)

# Convert to data.table (temporary)
type_b_dt <- as.data.table(type_b_sf)
type_b_sf_unique <- type_b_dt[, .SD[1], by = binary_hash] %>% st_as_sf()

# Summarize media_length_sec by state
result_b <- type_b_sf_unique %>%
  as.data.frame() %>%  # Convert back to dataframe for faster aggregation
  group_by(state) %>%
  summarise(total_media_length_sec = sum(media_length_sec, na.rm = TRUE)) %>%
  arrange(desc(total_media_length_sec))  # Optional: sort by highest total

# View the result
print(result_b)
# # A tibble: 19 × 2
# state                       total_media_length_sec
# <chr>                                        <dbl>
# 1 "Madhya Pradesh"                           79630. 
# 2 "Kerala"                                   21757. 
# 3 "Karnataka"                                16254. 
# 4 "Meghalaya"                                 5453. 
# 5 "Uttarakhand"                               4566. 
# 6 "Assam"                                     4180. 
# 7 "Andhra Pradesh"                            3741. 
# 8 "Haryana"                                   3484. 
# 9 "Tamil Nadu"                                3339. 
# 10 "NCT of Delhi"                              1702. 
# 11 "Andaman & Nicobar Islands"                 1578. 
# 12 "Rajasthan"                                 1140. 
# 13 "Goa"                                        979. 
# 14 "Uttar Pradesh"                              837. 
# 15 "Arunachal Pradesh"                          626. 
# 16 "Bihar"                                      618. 
# 17 "Gujarat"                                    166. 
# 18 "Punjab"                                     128. 
# 19 ""                                            71.1

# Remove the row for which state data is not available (unfortunately). This 
# is around 71 seconds:
result_b <- result_b %>%
                 filter(state != "")

#Add columns for time in hours (to 2 decimals) and minutes, with both minutes and 
# and seconds rounded to remove decimals
result_b <- result_b %>% mutate(total_media_length_min = ceiling(total_media_length_sec/60),
                                #Using ceiling above to include data which is less than 1
                                # which will be rounded to 1 minute
                                total_media_length_hr = round(total_media_length_sec/3600,2),
                                total_media_length_sec = round(total_media_length_sec, 0))

# Add the names of the states not in the result from the shapefile_valid$ST_NM (using
# the all_states object from type A)

# Full join to include all states
result_complete_b <- all_states %>%
  full_join(result_b, by = "state") %>%
  # Replace NA with 0 for the media length columns
  mutate(
    total_media_length_sec = ifelse(is.na(total_media_length_sec), 0, total_media_length_sec),
    total_media_length_min = ifelse(is.na(total_media_length_min), 0, total_media_length_min),
    total_media_length_hr = ifelse(is.na(total_media_length_hr), 0, total_media_length_hr)
  ) 

# View the result
print(result_complete_b)

# Save it as a csv if you want after sorting by recording duration/media length
res_b <- result_complete_b %>%
  arrange(desc(total_media_length_sec))  # Sort by media length

write.csv(res_b, "type_b_summary.csv")
rm(res_b)

# Now it needs to be saved as a dbf to be used as a shapefile

# Create a version with appropriate column names (10 chars max due to dbf format
# limitations)
colnames(result_complete_b) <- c("ST_NM", "TOT_SEC", "TOT_MIN", "TOT_HR")

# Save it
write.dbf(result_complete_b, "type_b.dbf")

# Now make a copy of the valid_shapefile
# Put it in a seperate folder for type a shapefile
# Replace the .dbf with the one downloaded 
# Rename all the other file types (.shp, .shx, etc) with the name of the .dbf (type_b)
# Now, it is ready to be used for creating a chloropleth in QGIS

# Total number of states covered by both Type A and Type B data =
length(union(result_a$state, result_b$state))
#[1] 24

# The states themselves
union(result_a$state, result_b$state)
# [1] "Kerala"                    "Karnataka"                 "Tamil Nadu"               
# [4] "Maharashtra"               "Uttarakhand"               "Madhya Pradesh"           
# [7] "Assam"                     "Himachal Pradesh"          "Jharkhand"                
# [10] "Andaman & Nicobar Islands" "Arunachal Pradesh"         "Jammu & Kashmir"          
# [13] "Andhra Pradesh"            "Goa"                       "Bihar"                    
# [16] "West Bengal"               "NCT of Delhi"              "Gujarat"                  
# [19] "Nagaland"                  "Haryana"                   "Punjab"                   
# [22] "Meghalaya"                 "Rajasthan"                 "Uttar Pradesh"  

-------------------
## Bubble plot ####
-------------------
  
-------------------------
#### Getting started ####
-------------------------
  
#Load in the geometry-fix ecoregions shapefile clipped to India
ecoregions <- st_read("ecoregions.gpkg")   

#Plot ecoregions
plot(ecoregions[2])

---------------------
#### Data preparation for Type A #####
---------------------
  
# Use the type_a_sf_unique object from the chloropleth stage
  
# Make sure shapefile has the same CRS (coordinate reference system)
if (st_crs(ecoregions) != st_crs(type_a_sf_unique)) {
    ecoregions <- st_transform(ecoregions, st_crs(type_a_sf_unique))
  }

# Check if there are points outside any ecoregion (NA values or empty)
missing_points <- sum(is.na(type_a_sf_unique$eco_name) | type_a_sf_unique$eco_name == "")
if (missing_points > 0) {
  message(paste(missing_points, "points are not within any state polygon"))
}
# All are inside

#Find out all the ecoregions which contains type A data:
unique(type_a_sf_unique$eco_name)
# [1] "Northwestern Himalayan alpine shrub and meadows"
# [2] "Chhota-Nagpur dry deciduous forests"            
# [3] "South Western Ghats montane rain forests"       
# [4] "South Western Ghats moist deciduous forests"    
# [5] "North Western Ghats montane rain forests"       
# [6] "East Deccan moist deciduous forests"            
# [7] "Central Deccan Plateau dry deciduous forests"   
# [8] "South Deccan Plateau dry deciduous forests"     
# [9] "Malabar Coast moist forests"                    
# [10] "Western Himalayan broadleaf forests"            
# [11] "Deccan thorn scrub forests"                     
# [12] "Lower Gangetic Plains moist deciduous forests"  
# [13] "Upper Gangetic Plains moist deciduous forests"  
# [14] "Himalayan subtropical pine forests"             
# [15] "Mizoram-Manipur-Kachin rain forests"            
# [16] "Brahmaputra Valley semi-evergreen forests"      
# [17] "Aravalli west thorn scrub forests"              
# [18] "Narmada Valley dry deciduous forests"           
# [19] "Himalayan subtropical broadleaf forests"        
# [20] "Indian Ocean"                                   
# [21] "Western Himalayan subalpine conifer forests"    
# [22] "Eastern Himalayan broadleaf forests"            
# [23] "North Western Ghats moist deciduous forests"    
# [24] "Andaman Islands rain forests"                   
# [25] "East Deccan dry-evergreen forests"     

# Note that "Indian Ocean" was added and not part of the original terrestrial 
# ecoregions classification. So, the data falls under 24 ecoregions + Indian Ocean

# Summarize media_length_sec by ecoregion
result_ecoregions_a <- type_a_sf_unique %>%
  as.data.frame() %>%  # Convert back to dataframe for faster aggregation
  group_by(eco_name) %>%
  summarise(total_media_length_sec = sum(media_length_sec, na.rm = TRUE)) %>%
  arrange(desc(total_media_length_sec))  # Optional: sort by highest total

# View the result
print(result_ecoregions_a)
# # A tibble: 25 × 2
# eco_name                                        total_media_length_sec
# <chr>                                                            <dbl>
#   1 South Western Ghats montane rain forests                        84905.
# 2 Malabar Coast moist forests                                     24175.
# 3 North Western Ghats montane rain forests                        21645.
# 4 Brahmaputra Valley semi-evergreen forests                        7965.
# 5 Upper Gangetic Plains moist deciduous forests                    7889.
# 6 South Deccan Plateau dry deciduous forests                       7370.
# 7 Northwestern Himalayan alpine shrub and meadows                  7370.
# 8 East Deccan moist deciduous forests                              5690 
# 9 Himalayan subtropical pine forests                               5490.
# 10 Deccan thorn scrub forests                                       4620.
# # ℹ 15 more rows
# # ℹ Use `print(n = ...)` to see more rows

# Find out the total duration of recording available in type A data:

# In seconds
sum(result_ecoregions_a$total_media_length_sec)
#[1] 204371.7

# In minutes
sum(result_ecoregions_a$total_media_length_sec)/60
#[1] 3406.195

# In hours
sum(result_ecoregions_a$total_media_length_sec)/3600
#[1] 56.76992

# Proportion of the ecoregion with the maximum amount of recordings
# (South Western Ghats montane rain forests) 
(max(result_ecoregions_a$total_media_length_sec)/
    sum(result_ecoregions_a$total_media_length_sec))*100
#[1] 41.54452

# The actual amount of minutes from South Western Ghats montane rain forests:
max(result_ecoregions_a$total_media_length_sec)/60
#[1] 1415.087

#Add columns for time in hours (to 2 decimals) and minutes, with both minutes and 
# and seconds rounded to remove decimals
result_ecoregions_a <- result_ecoregions_a %>% mutate(total_media_length_min = ceiling(total_media_length_sec/60),
                                                      #Using ceeiling above to include data which is less than 1
                                                      # which will be rounded to 1 minute
                                                      total_media_length_hr = round(total_media_length_sec/3600,2),
                                                      total_media_length_sec = round(total_media_length_sec, 0))

# View the result
head(result_ecoregions_a)
# A tibble: 6 × 4
# eco_name                                      total_media_length_sec total_media_length_min total_media_length_hr
# <chr>                                                          <dbl>                  <dbl>                 <dbl>
#   1 South Western Ghats montane rain forests                       84905                   1416                 23.6 
# 2 Malabar Coast moist forests                                    24175                    403                  6.72
# 3 North Western Ghats montane rain forests                       21645                    361                  6.01
# 4 Brahmaputra Valley semi-evergreen forests                       7965                    133                  2.21
# 5 Upper Gangetic Plains moist deciduous forests                   7889                    132                  2.19
# 6 South Deccan Plateau dry deciduous forests                      7370                    123                  2.05

#Add the names of the ecoregions not in the result from the ecoregions$ECO_NAME

# Get all unique ecoregions from the shapefile
all_ecoregions <- data.frame(eco_name = unique(ecoregions$ECO_NAME))

# Full join to include all ecoregions
result_ecoregions_a <- all_ecoregions %>%
  full_join(result_ecoregions_a, by = "eco_name") %>%
  # Replace NA with 0 for the media length columns
  mutate(
    total_media_length_sec = ifelse(is.na(total_media_length_sec), 0, total_media_length_sec),
    total_media_length_min = ifelse(is.na(total_media_length_min), 0, total_media_length_min),
    total_media_length_hr = ifelse(is.na(total_media_length_hr), 0, total_media_length_hr)
  ) %>%
  arrange(desc(total_media_length_sec))  # Optional: sort by media length

# Save this table
write.csv(result_ecoregions_a, "type_a_summary_ecoregions.csv")

# Add the column with the most recurring coordinate for an ecoregion (and not
# the centroid as there is at least one ecoregion which completely encloses
# another ecoregion):

# Find the most recurring coordinate (this is optimized for large datasets)
most_frequent_geom_a <- type_a_sf_unique %>%
  st_drop_geometry() %>%
  # Create coordinate ID
  mutate(
    coords = st_coordinates(type_a_sf_unique),
    coords_id = paste0(round(coords[,1], 5), "_", round(coords[,2], 5))
  ) %>%
  group_by(eco_name) %>%
  # Find most frequent coordinate ID
  count(coords_id) %>%
  slice_max(n, n = 1, with_ties = FALSE) %>%
  # Extract coordinates from ID
  mutate(
    lon = as.numeric(sub("_.*", "", coords_id)),
    lat = as.numeric(sub(".*_", "", coords_id))
  ) %>%
  select(eco_name, lon, lat)

# Change the coordinates for the Indian Ocean as it is too close to the Andaman
# Islands and won't be very clearly visible in the map. Change it to a little
# further away from the coast even if that was not the area where the animals
# were recorded from
most_frequent_geom_a$lat[most_frequent_geom_a$eco_name == "Indian Ocean"] <- 11.585339
most_frequent_geom_a$lon[most_frequent_geom_a$eco_name == "Indian Ocean"] <- 93.972708

# Convert to sf
most_frequent_geom_a <- st_as_sf(most_frequent_geom_a, 
                                 coords = c("lon", "lat"),
                                 crs = st_crs(type_a_sf_unique))

# Join with result_ecoregions_a
result_ecoregions_a <- result_ecoregions_a %>%
  left_join(most_frequent_geom_a, by = "eco_name")

#Convert to sf object
result_ecoregions_a <- st_as_sf(result_ecoregions_a)

---------------------
#### Data preparation for Type B #####
---------------------
  
# Use the type_b_sf_unique object from the chloropleth stage

# Check if there are points outside any ecoregion (NA values) or empty)
missing_points <- sum(is.na(type_b_sf_unique$eco_name) | type_b_sf_unique$eco_name == "" | type_b_sf_unique$eco_name == "#N/A")
if (missing_points > 0) {
  message(paste(missing_points, "points are not within any state polygon"))
}
# 2 points are not within any state polygon 
#(the same two recordings as shown in the chloropleth stage)

# If you want to verify, you can view which points are have eco_name as NA,
# and how many seconds/minutes each recording is
type_b_sf_unique %>% 
  filter(is.na(type_b_sf_unique$eco_name)| type_b_sf_unique$eco_name == "" | type_b_sf_unique$eco_name == "#N/A") %>%
  select(media_file_name, sci_name, state, eco_name, media_length_sec) %>%
  View()

# These have no coordinate or state information associated with it. So, they need
# to be removed as they can't be used.

# Remove the row for which no coordinate or state information is available (unfortunately)
# This around 71 seconds of data
type_b_sf_unique <- type_b_sf_unique %>%
  filter(!(eco_name == "#N/A"))

#Find out all the ecoregions which contains type B data:
unique(type_b_sf_unique$eco_name)
# [1] "East Deccan moist deciduous forests"           "Malabar Coast moist forests"                  
# [3] "South Western Ghats montane rain forests"      "Upper Gangetic Plains moist deciduous forests"
# [5] "South Deccan Plateau dry deciduous forests"    "Meghalaya subtropical forests"                
# [7] "Aravalli west thorn scrub forests"             "Central Deccan Plateau dry deciduous forests" 
# [9] "Deccan thorn scrub forests"                    "South Western Ghats moist deciduous forests"  
# [11] "Himalayan subtropical pine forests"            "Andaman Islands rain forests"                 
# [13] "Brahmaputra Valley semi-evergreen forests"     "East Deccan dry-evergreen forests"            
# [15] "Eastern Himalayan broadleaf forests"           "North Western Ghats montane rain forests"     
# [17] "North Western Ghats moist deciduous forests"   "Khathiar-Gir dry deciduous forests"           
# [19] "Lower Gangetic Plains moist deciduous forests" "Thar desert"                                  
# [21] "Nicobar Islands rain forests"                  "Narmada Valley dry deciduous forests"     

#Check if all the NAs have gone:
if (any(is.na(type_b_sf_unique$eco_name))) {
  message("Ecoregion names still have NA")
} else {
  message("No ecoregions are missing names")
}
# No ecoregions are missing names

# Summarize media_length_sec by ecoregion
result_ecoregions_b <- type_b_sf_unique %>%
  as.data.frame() %>%  # Convert back to dataframe for faster aggregation
  group_by(eco_name) %>%
  summarise(total_media_length_sec = sum(media_length_sec, na.rm = TRUE)) %>%
  arrange(desc(total_media_length_sec))  # Optional: sort by highest total

# View the result
print(result_ecoregions_b)
# # A tibble: 22 × 2
# eco_name                                      total_media_length_sec
# <chr>                                                          <dbl>
# 1 East Deccan moist deciduous forests                           80049.
# 2 Malabar Coast moist forests                                   20265.
# 3 South Western Ghats montane rain forests                      11110.
# 4 Meghalaya subtropical forests                                  7066.
# 5 Aravalli west thorn scrub forests                              4380.
# 6 South Western Ghats moist deciduous forests                    3707.
# 7 Upper Gangetic Plains moist deciduous forests                  3342.
# 8 Himalayan subtropical pine forests                             3161.
# 9 Central Deccan Plateau dry deciduous forests                   2903.
# 10 Deccan thorn scrub forests                                     2581.
# # ℹ 12 more rows
# # ℹ Use `print(n = ...)` to see more rows

# Find out the total duration of recording available in type B data:

# In seconds
sum(result_ecoregions_b$total_media_length_sec)
#[1] 150178.3

# In minutes
sum(result_ecoregions_b$total_media_length_sec)/60
#[1] 2502.971

# In hours
sum(result_ecoregions_b$total_media_length_sec)/3600
#[1] 41.71618

# Proportion of the ecoregion with the maximum amount of recordings
# (East Deccan moist deciduous forests) 
(max(result_ecoregions_b$total_media_length_sec)/
    sum(result_ecoregions_b$total_media_length_sec))*100
#[1] 53.30245

# The actual amount from East Deccan moist deciduous forests in minutes
max(result_ecoregions_b$total_media_length_sec)/60
#[1] 1334.145

#Add columns for time in hours (to 2 decimals) and minutes, with both minutes and 
# and seconds rounded to remove decimals
result_ecoregions_b <- result_ecoregions_b %>% mutate(total_media_length_min = ceiling(total_media_length_sec/60),
                                                      #Using ceiling above to include data which is less than 1
                                                      # which will be rounded to 1 minute
                                                      total_media_length_hr = round(total_media_length_sec/3600,2),
                                                      total_media_length_sec = round(total_media_length_sec, 0))

# View the result
head(result_ecoregions_b)
# # A tibble: 6 × 4
# eco_name                     total_media_length_sec total_media_length_min total_media_length_hr
# <chr>                                         <dbl>                  <dbl>                 <dbl>
#   1 East Deccan moist deciduous…                  80049                   1335                 22.2 
# 2 Malabar Coast moist forests                   20265                    338                  5.63
# 3 South Western Ghats montane…                  11110                    186                  3.09
# 4 Meghalaya subtropical fores…                   7066                    118                  1.96
# 5 Aravalli west thorn scrub f…                   4380                     74                  1.22
# 6 South Western Ghats moist d…                   3707                     62                  1.03

# Full join to include all ecoregions
result_ecoregions_b <- all_ecoregions %>%
  full_join(result_ecoregions_b, by = "eco_name") %>%
  # Replace NA with 0 for the media length columns
  mutate(
    total_media_length_sec = ifelse(is.na(total_media_length_sec), 0, total_media_length_sec),
    total_media_length_min = ifelse(is.na(total_media_length_min), 0, total_media_length_min),
    total_media_length_hr = ifelse(is.na(total_media_length_hr), 0, total_media_length_hr)
  ) %>%
  arrange(desc(total_media_length_sec))  # Optional: sort by media length

# Save it
write.csv(result_ecoregions_b, "type_b_summary_ecoregions.csv")

# Using dplyr on the sf object
# Create a table for minutes by each unique set of coordinates
type_b2 <- type_b_sf_unique %>%
  st_drop_geometry() %>%  # Remove geometry for grouping
  # Group by coordinates
  group_by(latitude, longitude) %>%
  summarise(
    media_length_sec_sum = sum(media_length_sec, na.rm = TRUE),
    count = n(),  # Count no. of media at each location
    .groups = "drop"
  ) %>%
  mutate(media_length_minutes_sum = ceiling(media_length_sec_sum/60)) %>%
  # Convert to sf
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = 4326,  # Use EPSG code or define CRS directly
           remove = FALSE)

# View result
head(type_b2)
# Simple feature collection with 6 features and 5 fields
# Geometry type: POINT
# Dimension:     XY
# Bounding box:  xmin: 93.8673 ymin: 6.8223 xmax: 93.9302 ymax: 6.9892
# Geodetic CRS:  WGS 84
# # A tibble: 6 × 6
# latitude longitude media_length_sec_sum count media_length_minutes_sum         geometry
# <dbl>     <dbl>                <dbl> <int>                    <dbl>      <POINT [°]>
#   1     6.82      93.9                174.      3                        3 (93.8673 6.8223)
# 2     6.88      93.9                273.      3                        5 (93.8885 6.8763)
# 3     6.92      93.9                 35.7     1                        1 (93.8929 6.9213)
# 4     6.94      93.9                 57.4     2                        1 (93.8981 6.9418)
# 5     6.97      93.9                 99.4     2                        2 (93.9302 6.9679)
# 6     6.99      93.9                 67.2     3                        2 (93.9144 6.9892)

#Clean out zeroes and na
type_b2 <- type_b2 %>%
  filter(
    !is.na(latitude),
    !is.na(longitude),
    latitude != 0,           # Remove zero latitude
    longitude != 0,          # Remove zero longitude
    media_length_minutes_sum!= 0      # Remove zero media length 
  )
head(type_b2)

# Perform spatial join - assign each point to an ecoregion (without the duplicates)
pts_with_ecoregions_b <- st_join(type_b2, ecoregions, join = st_within)

# Add the column with the most recurring coordinate for an ecoregion (and not
# the centroid as there is at least one ecoregion which completely encloses
# another ecoregion):

# Ensure points_with_ecoregions is an sf object
if (!inherits(pts_with_ecoregions_b, "sf")) {
  pts_with_ecoregions_b <- st_as_sf(pts_with_ecoregions_b)
}

# Getting the most recurring coordinate (by media_length_sum_sec) - 
# optimized version for large datasets
most_frequent_geom_b <- pts_with_ecoregions_b %>%
  st_drop_geometry() %>%
  # Create coordinate ID
  mutate(
    coords_id = paste0(longitude, "_", latitude)
  ) %>%
  group_by(ECO_NAME) %>%
  # Find coordinate with highest media_length_sec_sum
  slice_max(media_length_sec_sum, n = 1, with_ties = FALSE) %>%
  select(ECO_NAME, 
         lon = longitude, 
         lat = latitude)

# "Andaman Islands rain forests" is missing the most frequent coordinates since
# the coordinate(s) lie outside of the ecoregions boundary
# Manually find one coordinate (ideally the most frequent) that fall within this
# ecoregion. Manually add these data:
most_frequent_geom_b$lat[is.na(most_frequent_geom_b$ECO_NAME)] <- 11.503500
most_frequent_geom_b$lon[is.na(most_frequent_geom_b$ECO_NAME)] <- 92.70170

# Replace NA with "Andaman Islands rain forests"
most_frequent_geom_b$ECO_NAME[is.na(most_frequent_geom_b$ECO_NAME)] <-  "Andaman Islands rain forests"

# Convert to sf
most_frequent_b_sf <- st_as_sf(most_frequent_geom_b, 
                               coords = c("lon", "lat"),
                               crs = st_crs(pts_with_ecoregions_b))

# Rename "ECO_NAME" to "eco_name"
most_frequent_b_sf <- most_frequent_b_sf %>% rename(eco_name = ECO_NAME)

# Join with result_ecoregions_b
result_ecoregions_b <- result_ecoregions_b %>%
  left_join(most_frequent_b_sf, by = "eco_name")

#Convert to sf object
result_ecoregions_b <- st_as_sf(result_ecoregions_b)

-----------------------
### Plotting ####
-----------------------

##### Getting started ####
# Load the necessary packages:
library(ggplot2) # For plotting
library(RColorBrewer) # For colour-blind friendly palette selection
library(ggrepel) # For spacing text
library(ggspatial)  # For scale bar and north arrow

# For creating the palette

# For colouring, first identify which ecoregions have data
ecoregions_with_data_a <- ecoregions %>%
  filter(ECO_NAME %in% result_ecoregions_a$eco_name[result_ecoregions_a$total_media_length_min > 0])

ecoregions_with_data_b <- ecoregions %>%
  filter(ECO_NAME %in% result_ecoregions_b$eco_name[result_ecoregions_b$total_media_length_min > 0])

# As Indian Ocean is missing here, we would need the boundary for it.
# Load the shapefile available from here: https://doi.org/10.5281/zenodo.10778079
world <- st_read("World_Geographic_Regions/World_Geographic_Regionst.shp")
# Reading layer `World_Geographic_Regionst' from data source 
#   `/home/Bioacoustics dataset paper/figures/World_Geographic_Regions/World_Geographic_Regionst.shp' 
# using driver `ESRI Shapefile'
# Simple feature collection with 18 features and 6 fields
# Geometry type: MULTIPOLYGON
# Dimension:     XYZ
# Bounding box:  xmin: -180 ymin: -89.99807 xmax: 180.0019 ymax: 90
# z_range:       zmin: 0 zmax: 0
# Geodetic CRS:  WGS 84

#Check the regions available in this object
world$Region
# [1] "Antarctica"                               "Arctic Ocean"                            
# [3] "Asia"                                     "Australia"                               
# [5] "Baltic Sea"                               "Europe"                                  
# [7] "Indian Ocean"                             "Mediterranean Region"                    
# [9] "Africa"                                   "North America"                           
# [11] "North Atlantic Ocean"                     "North Pacific Ocean"                     
# [13] "Oceania"                                  "South America"                           
# [15] "South Atlantic Ocean"                     "South China and Easter Archipelagic Seas"
# [17] "South Pacific Ocean"                      "Southern Ocean"    

# Filter to just the Indian Ocean
ind_oc <- world %>% filter(Region == "Indian Ocean")
plot(ind_oc[3])

# Remove the large world object
rm(world)
# Clean up memory
gc()

# Prepare ind_oc to match the ecoregions data structure
ind_oc <- ind_oc %>%
  mutate(ECO_NAME = "Indian Ocean") %>%  # Add ECO_NAME column
  select(ECO_NAME, geometry) %>% # Keep only necessary columns
  rename(geom = geometry) %>% # Rename geometry to geom to match the eocregions format
  st_zm(drop = TRUE, what = "ZM")  # Drop Z and M dimensions

# Combine with ecoregions_with_data_a
ecoregions_with_data_a <- bind_rows(ecoregions_with_data_a,ind_oc)

# To get the same set of colours for ecoregions of both the type A and type B,
# the ecoregions_with_data object for both type A and type B should be merged
merged_eco_with_data <- union(ecoregions_with_data_a, ecoregions_with_data_b)

# So,  a total of 28 ecoregions + Indian Ocean had data contributions
unique(merged_eco_with_data$ECO_NAME)
# [1] "Andaman Islands rain forests"                   
# [2] "Brahmaputra Valley semi-evergreen forests"      
# [3] "Eastern Himalayan broadleaf forests"            
# [4] "Himalayan subtropical broadleaf forests"        
# [5] "Mizoram-Manipur-Kachin rain forests"            
# [6] "Himalayan subtropical pine forests"             
# [7] "Lower Gangetic Plains moist deciduous forests"  
# [8] "Chhota-Nagpur dry deciduous forests"            
# [9] "Upper Gangetic Plains moist deciduous forests"  
# [10] "Aravalli west thorn scrub forests"              
# [11] "Central Deccan Plateau dry deciduous forests"   
# [12] "East Deccan moist deciduous forests"            
# [13] "Narmada Valley dry deciduous forests"           
# [14] "North Western Ghats moist deciduous forests"    
# [15] "Malabar Coast moist forests"                    
# [16] "North Western Ghats montane rain forests"       
# [17] "Deccan thorn scrub forests"                     
# [18] "Northwestern Himalayan alpine shrub and meadows"
# [19] "Western Himalayan broadleaf forests"            
# [20] "Western Himalayan subalpine conifer forests"    
# [21] "South Deccan Plateau dry deciduous forests"     
# [22] "South Western Ghats moist deciduous forests"    
# [23] "South Western Ghats montane rain forests"       
# [24] "East Deccan dry-evergreen forests"              
# [25] "Indian Ocean"                                   
# [26] "Nicobar Islands rain forests"                   
# [27] "Meghalaya subtropical forests"                  
# [28] "Khathiar-Gir dry deciduous forests"             
# [29] "Thar desert"              

# Create a proper named vector of colors (for colourblind friendly palette 
# for ecoregions)
num_ecoregions <- n_distinct(merged_eco_with_data$ECO_NAME)

# If you want, you check which palettes in RColorBrewer are colorblind friendly
# RColorBrewer::display.brewer.all(colorblindFriendly = TRUE)

# Using Okabe-Ito palette (colorblind friendly)
base_okabe_ito <- palette.colors(9, palette = "Okabe-Ito")

# Get unique ecoregion names in a consistent order
ecoregion_names <- sort(merged_eco_with_data$ECO_NAME)  # Sort for consistency

# Generate colors for all ecoregions (okabe_ito)
# Interpolate to get more colors
color_palette <- colorRampPalette(base_okabe_ito, space = "Lab", 
                                  interpolate = "spline")
ecoregion_colors <- color_palette(num_ecoregions)

# Create a named vector - this is crucial.
color_vector <- setNames(ecoregion_colors, ecoregion_names)

# Check the colour of Indian Ocean and change it:
color_vector["Indian Ocean"] <- "#F0FFFF"  # Azure

##### Plot Type A ecoregions map ####
  
#Type A with the title changed to just Type A
bubble_map_type_a <- ggplot() +
  # Plot ALL ecoregions first in white (background)
  geom_sf(data = ecoregions, fill = "white", color = "darkgray", alpha = 1,
          linewidth = 0.1) +
  # Dummy layer for legend - all ecoregions (transparent)
  geom_sf(data = st_as_sf(merged_eco_with_data),  # Use ALL ecoregions, not just those with data
          aes(fill = ECO_NAME),  
          color = NA, 
          alpha = 0,  # Transparent - won't show on map
          show.legend = TRUE) +
  # Overlay ONLY ecoregions with data using their eco_name column
  geom_sf(data = ecoregions_with_data_a,  
          aes(fill = ECO_NAME),  # Use the ECO_NAME column
          color = NA, 
          alpha = 0.7,
          show.legend = FALSE) +
  # Add the bubbles
  geom_sf(data = result_ecoregions_a %>% filter(total_media_length_min > 0), 
          aes(size = total_media_length_min),
          #fill = "#EFBF04",  # Fixed color for bubbles
          fill = NA,  # No color for bubbles (transparent)
          shape = 21,
          alpha = 0.7,
          color = "black") + 
  # Add the individual points (from type_a_sf)
  geom_sf(
    data = type_a_sf,
    size = 0.5,
    color = "white",
    fill = NA,
    alpha = 0.3,
    shape = 16
  ) +
  # Add labels only for ecoregions with data
  geom_label_repel(data = result_ecoregions_a %>% 
                     filter(total_media_length_min > 0) %>%
                     st_coordinates() %>% 
                     as.data.frame() %>% 
                     bind_cols(result_ecoregions_a %>% 
                                 filter(total_media_length_min > 0) %>% 
                                 st_drop_geometry()),
                   aes(x = X, y = Y, label = total_media_length_min),
                   size = 3,
                   alpha = 0.65,
                   family = "Century Gothic",
                   force = 2,
                   label.padding = 0.25,
                   box.padding = 0.5,
                   point.padding = 0.5,
                   min.segment.length = 0,
                   max.overlaps = Inf,
                   seed = 269) +
  # Color scale for ecoregions (use a categorical palette)
  scale_fill_manual(
    values = color_vector,
    name = "Ecoregions with data",
    guide = guide_legend(override.aes = list(size = 3, alpha = 1),
                         ncol = 1
    )
  ) +
  #Size scale for bubbles
  scale_size_continuous(
    range = c(3, 20),
    breaks = pretty(result_ecoregions_a$total_media_length_min[result_ecoregions_a$total_media_length_min > 0], n = 5),
    guide = "none"
  ) +
  labs(x = '',
       y = '',
       title = "Type A") +
  theme_bw() +
  theme(
    plot.title = element_text(
      family = "Century Gothic",
      size = 14, face = "bold", hjust = 0.5
    ),
    plot.subtitle = element_text(
      family = "Century Gothic",
      size = 12, face = "italic", hjust = 0.5
    ),
    axis.title = element_text(
      family = "Century Gothic",
      size = 14, face = "bold"
    ),
    axis.text = element_text(family = "Century Gothic", size = 12), 
    legend.position = "right",
    legend.title = element_text(family = "Century Gothic", size = 10, face = "bold"), 
    legend.text = element_text(family = "Century Gothic", size = 8),
    panel.border = element_blank(),
    legend.key = element_rect(fill = NA),
    legend.key.size = unit(0.8, "lines"),
    panel.grid = element_blank()
  ) +
  # Add custom gridlines AFTER the shapefiles
  geom_sf(data = st_graticule(lat = seq(8, 37, by = 2.5),
                              lon = seq(70, 95, by = 2.5),
                              crs = st_crs(ecoregions)),
          color = "gray80",  # Light gray gridlines
          linewidth = 0.2,
          alpha = 0.5) +
  # Use coord_sf() with limits
  coord_sf(
    xlim = c(67.5, 97.5),
    ylim = c(5.5, 38),
    expand = FALSE
  ) +
  # Add scale_x/y_continuous inside coord_sf() for proper labeling
  scale_x_continuous(
    breaks = seq(70, 95, by = 3),
    labels = ~paste0(.x, "°E")
  ) +
  scale_y_continuous(
    breaks = seq(8, 37, by = 3),
    labels = ~paste0(.x, "°N")
  ) +
  # Add map elements
  annotation_scale(
    location = "br",
    width_hint = 0.2,
    pad_x = unit(0.2, "cm"),
    pad_y = unit(0.2, "cm"),
    text_family = "Century Gothic"
  ) +
  annotation_north_arrow(
    location = "tr",
    height = unit(1, "cm"),
    width = unit(1, "cm"),
    which_north = "true",
    pad_x = unit(0.2, "cm"),
    pad_y = unit(0.3, "cm"),
    style = north_arrow_fancy_orienteering(text_family = "Century Gothic")
  ) 

bubble_map_type_a

##### Plot Type B ecoregions map ####

# Type B with north arrow, scale bar, latitude, and legends removed; and titled
# changed to just Type B
bubble_map_type_b <- ggplot() +
  # Plot ALL ecoregions first in white (background)
  geom_sf(data = ecoregions, fill = "white", color = "darkgray", alpha = 1,
          linewidth = 0.1) +
  # Overlay ONLY ecoregions with data using their ECO_NAME column
  geom_sf(data = ecoregions_with_data_b, 
          aes(fill = ECO_NAME),  # Use the ECO_NAME column
          color = NA, 
          alpha = 0.7,
          show.legend = FALSE) +
  # Add the bubbles
  geom_sf(data = result_ecoregions_b %>% filter(total_media_length_min > 0), 
          aes(size = total_media_length_min),
          #fill = "#EFBF04",  # Fixed color for bubbles
          fill = NA,  # No fill color for bubbles
          shape = 21,
          alpha = 0.7,
          color = "black") + 
  # Add the individual points (from type_b2)
  geom_sf(
    data = type_b2,
    size = 0.5,
    color = "white",
    fill = NA,
    alpha = 0.3,
    shape = 16,
    #stroke = 0.5
  ) +
  # Add labels only for ecoregions with data
  geom_label_repel(data = result_ecoregions_b %>% 
                     filter(total_media_length_min > 0) %>%
                     st_coordinates() %>% 
                     as.data.frame() %>% 
                     bind_cols(result_ecoregions_b %>% 
                                 filter(total_media_length_min > 0) %>% 
                                 st_drop_geometry()),
                   aes(x = X, y = Y, label = total_media_length_min),
                   size = 3,
                   alpha = 0.65,
                   family = "Century Gothic",
                   force = 2,
                   label.padding = 0.25,
                   box.padding = 0.5,
                   point.padding = 0.5,
                   min.segment.length = 0,
                   max.overlaps = Inf,
                   seed = 269) +
  # Color scale for ecoregions (use a categorical palette)
  scale_fill_manual(
    values = color_vector,
    name = "Ecoregions with data",
    guide = guide_legend(override.aes = list(size = 3),
                         ncol = 1
    )
  ) +
  #Size scale for bubbles
  scale_size_continuous(
    range = c(3, 20),
    breaks = pretty(result_ecoregions_b$total_media_length_min[result_ecoregions_b$total_media_length_min > 0], n = 5),
    guide = "none"
  ) +
  labs(x = '',
       y = '',
       title = "Type B") +
  theme_bw() +
  theme(
    plot.title = element_text(
      family = "Century Gothic",
      size = 14, face = "bold", hjust = 0.5
    ),
    plot.subtitle = element_text(
      family = "Century Gothic",
      size = 12, face = "italic", hjust = 0.5
    ),
    axis.title = element_text(
      family = "Century Gothic",
      size = 14, face = "bold"
    ),
    axis.text = element_text(family = "Century Gothic", size = 12), 
    legend.position = "right",
    legend.title = element_text(family = "Century Gothic", size = 10, face = "bold"), 
    legend.text = element_text(family = "Century Gothic", size = 8),
    panel.border = element_blank(),
    legend.key = element_rect(fill = NA),
    legend.key.size = unit(0.8, "lines"),
    panel.grid = element_blank()
  ) +
  # Add custom gridlines AFTER the shapefiles
  geom_sf(data = st_graticule(lat = seq(8, 37, by = 2.5),
                              lon = seq(70, 95, by = 2.5),
                              crs = st_crs(ecoregions)),
          color = "gray80",  # Light gray gridlines
          linewidth = 0.2,
          alpha = 0.5) +
  # Use coord_sf() with limits
  coord_sf(
    xlim = c(67.5, 97.5),
    ylim = c(5.5, 38),
    expand = FALSE
  ) +
  # Add scale_x/y_continuous inside coord_sf() for proper labeling
  scale_x_continuous(
    breaks = seq(70, 95, by = 3),
    labels = ~paste0(.x, "°E")
  ) +
  scale_y_continuous(
    breaks = seq(8, 37, by = 3)
  ) +
  theme(
    axis.text.y = element_blank(),  # Remove y-axis labels
    axis.ticks.y = element_blank()   # Remove y-axis ticks too
  )

bubble_map_type_b

##### Create the combined plot #### 

#install.packages("patchwork")
library(patchwork)

# Horizontal stacking
combined <- bubble_map_type_a + bubble_map_type_b +
  plot_layout(nrow = 1)

# stacked up-and-down
#combined <- bubble_map_type_a + bubble_map_type_b +
#  plot_layout(ncol = 1)

# Save
ggsave("combined_plots_it3.png", combined, width = 18, height = 9, dpi = 300)

#ggsave("combined_plots_vertical.png", combined, width = 9, height = 18, dpi = 300)

# Taxonomic plots ####

### Non-aves ####

#### Data preparation for Type A ####

# Read in the annotation data for type A
# install.packages(data.table)
library(data.table)
anno_type_a <- as.data.frame(fread("anno_Jan31.csv"))

# See the structure
str(anno_type_a)
# 'data.frame':	40564 obs. of  11 variables:
#   $ begin_time_s   : num  416.9 102.3 49.7 111.7 157 ...
# $ end_time_s     : num  416.9 103.1 49.8 112 157.3 ...
# $ low_freq_hz    : num  1 1626 1 6691 1914 ...
# $ high_freq_hz   : num  44000 4389 44000 7807 3453 ...
# $ media_file_name: chr  "240704-001.wav" "SLT  ZOOM0110_Tr1" "240702-003.wav" "HP4008U_20200307_181500" ...
# $ media_id       : chr  "8914bd91-603e-4dbb-8aba-1ac6bc91cd4a" "775a1efd-db49-42b8-85a4-fb509b04c312" "6954f22e-465b-4e4a-965a-47c26640c4a9" "8648a8fc-10ec-4f21-85e6-7d35ae8b0b4e" ...
# $ organism_seen  : logi  NA TRUE NA NA NA NA ...
# $ notes          : chr  "vocal_unit: note" "" "vocal_unit: note" "" ...
# $ sci_name       : chr  "Raorchestes luteolus" "Trochalopteron lineatum" "Raorchestes hassanensis" "Muscicapa dauurica" ...
# $ taxa_info      : chr  "{\"\"rank\"\": \"\"SPECIES\"\", \"\"class\"\": \"\"Amphibia\"\", \"\"genus\"\": \"\"Raorchestes\"\", \"\"order\"| __truncated__ "{\"\"rank\"\": \"\"SPECIES\"\", \"\"class\"\": \"\"Aves\"\", \"\"genus\"\": \"\"Trochalopteron\"\", \"\"order\""| __truncated__ "{\"\"rank\"\": \"\"SPECIES\"\", \"\"class\"\": \"\"Amphibia\"\", \"\"genus\"\": \"\"Raorchestes\"\", \"\"order\"| __truncated__ "{\"\"rank\"\": \"\"SPECIES\"\", \"\"class\"\": \"\"Aves\"\", \"\"genus\"\": \"\"Muscicapa\"\", \"\"order\"\": \"| __truncated__ ...
#  $ id             : chr  "00005bc2-8fb1-4188-9cd4-fd5e3ed21eb2" "0001a792-297b-4126-9281-7ca387712681" "0001d6a3-4180-47e4-bbd0-f4946b31758b" "000205a0-4a49-414a-9bcf-12d2bd577fd9" ...

# Fix the JSON strings by replacing double quotes
annota <- anno_type_a %>%
  mutate(taxa_info = gsub('""', '"', taxa_info))

# Match any whitespace in the taxa_info and quote variations, and filter them out
# For example: {""rank"": null, ""class"": null, ""genus"": null, ""order"": null, ""family"": null, ""phylum"": null, ""status"": null, ""kingdom"": null, ""classKey"": null, ""genusKey"": null, ""orderKey"": null, ""usageKey"": null, ""familyKey"": null, ""matchType"": ""NONE"", ""phylumKey"": null, ""confidence"": 100, ""kingdomKey"": null, ""speciesKey"": null, ""canonicalName"": null, ""scientificName"": null, ""acceptedUsageKey"": null}
annota <- annota %>%
  filter(!grepl('"rank"\\s*:\\s*null\\s*,', taxa_info))
# The above step removes all the non-organism annotations like noise and wind.

#Remove Homo sapiens (Humans) from the data to keep it to only wild species
annota <- annota %>%
  filter(!grepl("Homo sapiens", sci_name))

#Parse it:
parsed_data <- lapply(annota$taxa_info, fromJSON)

# Convert to dataframe and bind to original
df_parsed_a <- bind_rows(parsed_data)

# Remove the object 'parsed_data' as it is large
rm(parsed_data)

# Combine with original dataframe (excluding the original taxa_info column)
ta <- cbind(annota %>% select(-taxa_info), df_parsed_a %>% 
              select(c(rank, kingdom, phylum, class, order, family, genus, confidence, speciesKey)))

# Select only those rows which are unique species for a given media_file_name
# (to make it comparable to type B)
ta <- ta %>%
  distinct(`media_file_name`, sci_name, .keep_all = TRUE)

# Filter to only non-aves
non_aves_type_a <- ta %>%
  filter(!grepl("Aves", `class`))

# Prepare the necessary data
# Create class counts
class_counts_a <- non_aves_type_a %>%
  count(class, name = "count") %>%
  mutate(class = ifelse(is.na(class), "Unknown", class)) %>%
  arrange(desc(count))

#Remove the Bacillariophyceae
class_counts_a <- class_counts_a %>% filter(class != "Bacillariophyceae")
#and add one in 'Unknown' instead:
class_counts_a$count[class_counts_a$class == "Unknown"] <- 9

# Create order counts within each class
order_counts_a <- non_aves_type_a %>%
  mutate(
    class = ifelse(is.na(class), "Unknown", class),
    order = ifelse(is.na(order), "Unknown", order)
  ) %>%
  count(class, order, name = "count") %>%
  arrange(class, desc(count))

print(order_counts_a)
#                class             order count
# 1           Amphibia             Anura   277
# 2  Bacillariophyceae Thalassiophysales     1
# 3            Insecta        Orthoptera    63
# 4            Insecta         Hemiptera    21
# 5            Insecta       Hymenoptera     5
# 6            Insecta           Unknown     4
# 7            Insecta       Trichoptera     1
# 8           Mammalia          Primates    59
# 9           Mammalia        Chiroptera    39
# 10          Mammalia          Rodentia    24
# 11          Mammalia         Carnivora     8
# 12          Mammalia           Sirenia     6
# 13          Mammalia      Artiodactyla     2
# 14          Mammalia    Perissodactyla     1
# 15          Squamata           Unknown     1
# 16           Unknown           Unknown     7
# 17           Unknown      Siluriformes     1

#Remove the Bacillariophyceae
order_counts_a <- order_counts_a %>% filter(class != "Bacillariophyceae")

# The fish Rita rita lacks the class name in GBIF even they the species has 
# order name there. So, get the information from Wikipedia. The class is
# Actinopterygii. Replace it:
order_counts_a$class[order_counts_a$order == "Siluriformes"] <- "Actinopterygii"

#Remove the row with both class and order given as unknown
order_counts_a <- order_counts_a %>% filter(class != "Unknown")

# Squamata is an order, not a class (as wrongly given in the GBIF backbone)
# So, fix this in the order_counts_a
order_counts_a$order[order_counts_a$class == "Squamata"] <- "Squamata"
order_counts_a$class[order_counts_a$order == "Squamata"] <- "Reptilia"

# Create data with class total, class %, and label for the figure 
order_counts_nested_a <- order_counts_a %>%
  group_by(class) %>%
  mutate(
    class_total = sum(count),
    class_percent = count / class_total * 100,
    order_label = paste0(order, ": ", count, " (", round(class_percent, 2), "%)")
  ) %>%
  ungroup()

# Check the structure
str(order_counts_nested_a)
# tibble [15 × 6] (S3: tbl_df/tbl/data.frame)
# $ class        : chr [1:15] "Amphibia" "Insecta" "Insecta" "Insecta" ...
# $ order        : chr [1:15] "Anura" "Orthoptera" "Hemiptera" "Hymenoptera" ...
# $ count        : int [1:15] 277 63 21 5 4 1 59 39 24 8 ...
# $ class_total  : int [1:15] 277 94 94 94 94 94 139 139 139 139 ...
# $ class_percent: num [1:15] 100 67.02 22.34 5.32 4.26 ...
# $ order_label  : chr [1:15] "Anura: 277 (100%)" "Orthoptera: 63 (67.02%)" "Hemiptera: 21 (22.34%)" "Hymenoptera: 5 (5.32%)" ...

#### Data preparation for Type B ####

# Filter to only non-aves
non_aves_type_b <- type_b_sf %>%
                   st_drop_geometry() %>%
                   filter(!grepl("Aves", `class`))

# Fix the NA issues
non_aves_type_b$class[non_aves_type_b$sci_name == "Anura"] <- "Amphibia"
non_aves_type_b$order[non_aves_type_b$sci_name == "Anura"] <- "Anura"
non_aves_type_b$class[non_aves_type_b$sci_name == "Indopurana cheeveeda"] <- "Insecta"
non_aves_type_b$order[non_aves_type_b$sci_name == "Indopurana cheeveeda"] <- "Hemiptera"
#Remove the row with class and order and given as unknown
non_aves_type_b <- non_aves_type_b %>% filter(class != "Unknown")

# Prepare the data
# Create class counts
class_counts_b <- non_aves_type_b %>%
  count(class, name = "count") %>%
  mutate(class = ifelse(is.na(class), "Unknown", class)) %>%
  arrange(desc(count))

print(class_counts_b)
# class count
# class count
# 1  Insecta    84
# 2 Mammalia    77
# 3 Amphibia    73

# Create order counts within each class
order_counts_b <- non_aves_type_b %>%
  mutate(
    class = ifelse(is.na(class), "Unknown", class),
    order = ifelse(is.na(order), "Unknown", order)
  ) %>%
  count(class, order, name = "count") %>%
  arrange(class, desc(count))

print(order_counts_b)
# class        order count
# 1 Amphibia        Anura    73
# 2  Insecta   Orthoptera    70
# 3  Insecta    Hemiptera    12
# 4  Insecta      Unknown     2
# 5 Mammalia   Chiroptera    57
# 6 Mammalia     Rodentia    10
# 7 Mammalia Artiodactyla     5
# 8 Mammalia    Carnivora     3
# 9 Mammalia     Primates     2

# Create data with class total, class %, and label for the figure 
order_counts_nested_b <- order_counts_b %>%
  group_by(class) %>%
  mutate(
    class_total = sum(count),
    class_percent = count / class_total * 100,
    order_label = paste0(order, ":", count, " (", round(class_percent, 2), "%)")
  ) %>%
  ungroup()

# Check the structure:
str(order_counts_nested_b)
# tibble [9 × 6] (S3: tbl_df/tbl/data.frame)
# $ class        : chr [1:9] "Amphibia" "Insecta" "Insecta" "Insecta" ...
# $ order        : chr [1:9] "Anura" "Orthoptera" "Hemiptera" "Unknown" ...
# $ count        : int [1:9] 73 70 12 2 57 10 5 3 2
# $ class_total  : int [1:9] 73 84 84 84 77 77 77 77 77
# $ class_percent: num [1:9] 100 83.33 14.29 2.38 74.03 ...
# $ order_label  : chr [1:9] "Anura:73 (100%)" "Orthoptera:70 (83.33%)" "Hemiptera:12 (14.29%)" "Unknown:2 (2.38%)" ...

#### Plotting #####

##### Getting started #####

# Setting colour 
# First, create a proper named vector of colors (for colourblind friendly palette)
#For type A and B combined
num_orders <- n_distinct(union(order_counts_b$order, order_counts_a$order))

# Choose a colorblind friendly palette

# Okabe-Ito palette
base_okabe_ito <- palette.colors(9, palette = "Okabe-Ito")

# Get unique ecoregion names in a consistent order
order_names <- sort(unique(union(order_counts_b$order, order_counts_a$order)))

# Generate colors for all orders (okabe_ito)
# Interpolate to get more colors
color_palette <- colorRampPalette(base_okabe_ito, space = "Lab", 
                                  interpolate = "spline")
order_colors <- color_palette(num_orders)

# Create a named vector - this is crucial.
color_vector_order <- setNames(order_colors, order_names)

##### Plot Type A non-aves stacked bar-plot #####

non_aves_a <- ggplot(order_counts_nested_a, 
                                     aes(x = reorder(class, -class_total), 
                                         y = count, 
                                         fill = reorder(order, -count))) +
  geom_bar(stat = "identity", position = position_stack(reverse = TRUE), color = "black",
           show.legend = FALSE) +
  
  # For larger segments: normal labels
  geom_text(data = order_counts_nested_a %>% filter(count > max(count) * 0.05),
            aes(label = order_label),
            position = position_stack(vjust = 0.5, reverse = TRUE),
            color = "white", size = 3.2, fontface = "bold",
            family = "Century Gothic") +
  
  # For small segments: ggrepel callouts
  geom_text_repel(data = order_counts_nested_a %>% 
                    filter(count <= max(count) * 0.05 & count > 0),
                  aes(label = order_label,
                      y = class_total),  # Start from top of bar
                  direction = "y",  # Keep vertical
                  nudge_y = max(order_counts_nested_a$class_total) * 0.05,  # Move up
                  segment.size = 0.3,
                  segment.color = "gray50",
                  box.padding = 0.3,
                  point.padding = 0,
                  min.segment.length = 0,
                  size = 3.7,
                  color = "black",
                  #fontface = "bold",
                  family = "Century Gothic") +
  scale_fill_manual(
    values = color_vector_order,
    name = "Order",
    guide = guide_legend(override.aes = list(size = 3),
                         ncol = 1)
  )+
  labs(
    title = "Type A",
    x = "Class",
    y = "Summed label count of species within each recording falling within an order",
    caption = paste("Total count:", sum(order_counts_nested_a$count))
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      family = "Century Gothic",
      size = 14, hjust = 0.5
    ),
    plot.subtitle = element_text(
      family = "Century Gothic",
      size = 12, face = "italic", hjust = 0.5
    ),
    axis.title = element_text(
      family = "Century Gothic",
      size = 14
    ),
    plot.caption = element_text(
      family = "Century Gothic",
      size = 10, face = "plain", hjust = 1  # hjust = 1 for right-aligned
    ),
    axis.text = element_text(family = "Century Gothic", size = 12), 
    legend.position = "right",
    legend.title = element_text(family = "Century Gothic", size = 10), 
    legend.text = element_text(family = "Century Gothic", size = 8),
    panel.border = element_blank(),
    legend.key = element_rect(fill = NA),
    legend.key.size = unit(0.8, "lines"),
    panel.grid = element_blank()
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))  # Add some space at top

non_aves_a

Change the thresholding tactic for the smaller labels

##### Plot Type B non-aves stacked bar-plot #####

# Create the nested stacked bar plot
non_aves_b <- ggplot(order_counts_nested_b, 
                                     aes(x = reorder(class, -class_total), 
                                         y = count, 
                                         fill = reorder(order, -count))) +
  geom_bar(stat = "identity", position = position_stack(reverse = TRUE), color = "black",
           show.legend = FALSE) +
  # Add count labels
  geom_text(aes(label = order_label),
            position = position_stack(vjust = 0.5, reverse = TRUE),
            color = "white", size = 4, fontface = "bold",
            family = "Century Gothic") +
  scale_fill_manual(
    values = color_vector_order,
    name = "Order",
    guide = guide_legend(override.aes = list(size = 3),
                         ncol = 1)
  )+
  labs(
    title = "Type B",
    x = "Class",
    caption = paste("Total count:", sum(order_counts_nested_b$count))
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      family = "Century Gothic",
      size = 14, face = "bold", hjust = 0.5
    ),
    plot.subtitle = element_text(
      family = "Century Gothic",
      size = 12, face = "italic", hjust = 0.5
    ),
    axis.title = element_text(
      family = "Century Gothic",
      size = 14, face = "bold"
    ),
    plot.caption = element_text(
      family = "Century Gothic",
      size = 10, face = "plain", hjust = 1  # hjust = 1 for right-aligned
    ),
    axis.text = element_text(family = "Century Gothic", size = 12), 
    legend.position = "right",
    legend.title = element_text(family = "Century Gothic", size = 10, face = "bold"), 
    legend.text = element_text(family = "Century Gothic", size = 8),
    panel.border = element_blank(),
    legend.key = element_rect(fill = NA),
    legend.key.size = unit(0.8, "lines"),
    panel.grid = element_blank(),
    axis.title.y = element_blank()
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))  # Add some space at top

non_aves_b

##### Create the combined plot #####

# Horizontal
combined_non_aves <- non_aves_a + non_aves_b +
                     plot_layout(nrow = 1)

#stacked up-and-down
#combined <- bubble_map_type_a + bubble_map_type_b +
#  plot_layout(ncol = 1)


# Save
ggsave("combined_plots_orders_horiztonal_it3.png", combined_non_aves, width = 18, 
       height = 9, dpi = 300)


#ggsave("combined_plots_vertical.png", combined, width = 9, height = 18, dpi = 300)

### Aves - order and class ####

#### Data preparation for Type A ####

# Filter to only aves
aves_type_a <- ta %>%
               filter(grepl("Aves", `class`))

# Fix NA issues:
aves_type_a$order[aves_type_a$sci_name == "Tachyspiza badia"] <- "Accipitriformes"
aves_type_a$family[aves_type_a$sci_name == "Tachyspiza badia"] <- "Accipitridae"
aves_type_a$order[grepl("^Plocealauda", aves_type_a$sci_name)] <- "Passeriformes"
aves_type_a$family[grepl("^Plocealauda", aves_type_a$sci_name)] <- "Alaudidae"

# Create order counts within each class
family_counts_aves_a <- aves_type_a %>%
  mutate(
    order = ifelse(is.na(order), "Unknown", order),
    family = ifelse(is.na(family), "Unknown", family)
  ) %>%
  count(order, family, name = "count") %>%
  arrange(order, desc(count)) %>%
  filter(!order == "Unknown")%>%
  group_by(order) %>%
  mutate(
    order_total = sum(count),
    order_percent = count / order_total * 100,
    family_label = paste0(family,"\n",round(order_percent, 2), "%")
  ) %>%
  ungroup()

#### Data preparation for Type B ####

# Filter to only aves
aves_type_b <- type_b_sf %>%
               st_drop_geometry() %>%
               filter(grepl("Aves", `class`))

# Fix NA issues:
aves_type_b$order[aves_type_b$sci_name == "Tachyspiza badia"] <- "Accipitriformes"
aves_type_b$family[aves_type_b$sci_name == "Tachyspiza badia"] <- "Accipitridae"
aves_type_b$order[grepl("^Plocealauda", aves_type_b$sci_name)] <- "Passeriformes"
aves_type_b$family[grepl("^Plocealauda", aves_type_b$sci_name)] <- "Alaudidae"

# Create order counts within each class
family_counts_aves_b <- aves_type_b %>%
  mutate(
    order = ifelse(is.na(order), "Unknown", order),
    family = ifelse(is.na(family), "Unknown", family)
  ) %>%
  count(order, family, name = "count") %>%
  arrange(order, desc(count)) %>%
  filter(!order == "Unknown")%>%
  group_by(order) %>%
  mutate(
    order_total = sum(count),
    order_percent = count / order_total * 100,
    family_label = paste0(family,"\n",round(order_percent, 2), "%")
  ) %>%
  ungroup()

#### Plotting #####

##### Getting started #####

# Create a proper named vector of colors (for both type A and type B combined)
num_orders <- n_distinct(union(family_counts_aves_a$order, family_counts_aves_b$order))

# Choose a colorblind friendly palette
#RColorBrewer Set3 (good for categorical)
order_colors <- colorRampPalette(brewer.pal(12, "Set3"))(num_orders)

# Get unique order names in a consistent order
# Sort for consistency
order_names <- sort(unique(union(family_counts_aves_a$order, family_counts_aves_b$order)))

# Create a named vector - this is crucial.
color_vector_order <- setNames(order_colors, order_names)

# For getting the legend with all the names:
merged_aves_with_data <- union(family_counts_aves_a, family_counts_aves_b)

##### Plotting Type A aves treemap ####

# Load the treemapify library (in addition to ggplot2 already loaded)
#install.packages("treemapify")
library(treemapify)

treemap_aves_a <- ggplot(family_counts_aves_a, 
                  aes(area = sqrt(count),  # TRANSFORMATION APPLIED HERE
                      fill = order,
                      subgroup = order,
                      subgroup2 = family,
                      label = family_label)) +
  geom_treemap() +
  geom_treemap_subgroup_border(color = "black", size = 2) +
  geom_treemap_subgroup2_border(color = "black", size = 0.8) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(
      family = "Century Gothic",
      size = 18, hjust = 0.5
    ),
    legend.position = "right",
    legend.title = element_text(family = "Century Gothic", size = 14), 
    legend.text = element_text(family = "Century Gothic", size = 12),
    legend.key.size = unit(1.2, "lines")
  ) +
  
  # Use smaller text that reflows within boxes
  geom_treemap_text(
    color = "black",
    place = "center",
    grow = TRUE,        # Allow text to shrink for small boxes
    min.size = 2,       # Minimum text size (pts)
    padding.x = grid::unit(1, "mm"),  # Small padding
    padding.y = grid::unit(1, "mm"),
    family = "Century Gothic"
  ) +
  
  labs(
    title = "Type A"
  ) +
  scale_fill_manual(
    values = color_vector_order,
    name = "Order",
    guide = guide_legend(override.aes = list(size = 3),
                         ncol = 1
    ))

treemap_aves_a

##### Plotting Type B aves treemap ####

treemap_aves_b <- ggplot(family_counts_aves_b, 
                         aes(area = sqrt(count),  # TRANSFORMATION APPLIED HERE
                             fill = order,
                             subgroup = order,
                             subgroup2 = family,
                             label = family_label)) +
  geom_treemap() +
  geom_treemap_subgroup_border(color = "black", size = 2) +
  geom_treemap_subgroup2_border(color = "black", size = 0.8) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(
      family = "Century Gothic",
      size = 18, hjust = 0.5
    ),
    legend.position = "right",
    legend.title = element_text(family = "Century Gothic", size = 14), 
    legend.text = element_text(family = "Century Gothic", size = 12),
    legend.key.size = unit(1.2, "lines")
  ) +
  
  # Use smaller text that reflows within boxes
  geom_treemap_text(
    color = "black",
    place = "center",
    grow = TRUE,        # Allow text to shrink for small boxes
    min.size = 2,       # Minimum text size (pts)
    padding.x = grid::unit(1, "mm"),  # Small padding
    padding.y = grid::unit(1, "mm"),
    family = "Century Gothic"
  ) +
  
  labs(
    title = "Type B"
  ) +
  scale_fill_manual(
    values = color_vector_order,
    name = "Order",
    guide = guide_legend(override.aes = list(size = 3),
                         ncol = 1
    ))

treemap_aves_b

##### Create the combined plot #####

#stacked up-and-down
combined_aves <- treemap_aves_a + treemap_aves_b +
                  plot_layout(ncol = 1)

ggsave("combined_treemap_aves_vertical_it1.png", combined_aves, width = 14, height = 18, dpi = 300)




#ggsave("type_b_order_family_treemap_it2a.jpg", treemap, width = 14, height = 9, dpi = 300)

# Taxonomic data ####

### Type A ####

# Check the taxonomic distribution of the data (at label level)
table(ta$rank)
# CLASS     FAMILY       FORM      GENUS    KINGDOM      ORDER     PHYLUM    SPECIES SUBSPECIES   UNRANKED 
# 109        378         16        802          1         67         11      38221        226          5 

# Check the number of kingdom, phylum, class, order, family, genus, and species
table(ta$kingdom)
# Animalia Chromista 
# 39833         3 
# Chromista is wrong. So, only one kingdom
table(ta$phylum)
# Arthropoda   Chordata Ochrophyta 
# 541          39291          3 
# Ochrophyta is wrong. So, just 2 phyla.
table(ta$class)
# Amphibia              Aves Bacillariophyceae           Insecta          Mammalia          Squamata 
# 16244             22124                 3               530               911                 1 
# Bacillariophyceae is wrong. So, just 5 classes.
table(ta$order)
# Accipitriformes      Anseriformes             Anura       Apodiformes      Artiodactyla    Bucerotiformes 
#             268                12             16244                 1                13               103 
# Caprimulgiformes         Carnivora   Charadriiformes        Chiroptera     Columbiformes     Coraciiformes 
#              441                55               124               190               554               316 
#     Cuculiformes     Falconiformes       Galliformes        Gruiformes         Hemiptera       Hymenoptera 
#              807                 6               485               264               253                 9 
#       Orthoptera     Passeriformes    Pelecaniformes    Perissodactyla        Piciformes  Podicipediformes 
#              246             16781                19                 1              1182                92 
#         Primates    Psittaciformes  Pteroclidiformes          Rodentia      Siluriformes           Sirenia 
#              206               197                10               126                11               320 
#     Strigiformes Thalassiophysales       Trichoptera     Trogoniformes 
#              149                 3                16                 8 
length(unique(ta$order))
# [1] 35
# Thalassiophysales is wrong. So, 34 classes.
table(ta$family)
# Accipitridae    Acrocephalidae      Aegithalidae      Aegithinidae         Alaudidae       Alcedinidae 
# 268               127                38               315                89               269 
# Anatidae         Aphididae            Apidae          Apodidae          Ardeidae         Artamidae 
# 12                41                 1                 1                18                18 
# Bagridae       Bucerotidae         Bufonidae        Burhinidae     Campephagidae           Canidae 
# 11                71                76                18               149                53 
# Caprimulgidae      Catenulaceae   Cercopithecidae        Certhiidae          Cervidae         Cettiidae 
# 441                 3               148                 6                13                67 
# Charadriidae     Chloropseidae         Cicadidae      Cisticolidae        Columbidae        Coraciidae 
# 65                 7                53               960               554                 2 
# Corvidae         Cuculidae         Dicaeidae        Dicruridae        Dugongidae    Emballonuridae 
# 914               807               227               486               320                41 
# Emberizidae           Equidae       Estrildidae         Eumenidae        Falconidae           Felidae 
# 73                 1               108                 2                 6                 2 
# Fringillidae        Gekkonidae         Gryllidae    Hipposideridae      Hirundinidae     Ichneumonidae 
# 223                 1               159                 5               130                 1 
# Irenidae          Laniidae    Leiothrichidae         Lorisidae      Megalaimidae         Meropidae 
# 144               145              1551                58              1002                45 
# Molossidae       Monarchidae      Motacillidae      Muscicapidae     Nectariniidae      Notonectidae 
# 18                59               160              2026               693               159 
# Nyctibatrachidae       Oecanthidae         Oriolidae           Paridae        Passeridae      Pellorneidae 
# 126                 1               178                13               220               391 
# Phasianidae    Phylloscopidae           Picidae          Pittidae         Ploceidae       Pnoepygidae 
# 485               484               180               554                 1                13 
# Podicipedidae       Prunellidae       Psittacidae     Pteroclididae      Pteropodidae      Pycnonotidae 
# 92               190               196                10                 5              4011 
# Rallidae           Ranidae     Rhacophoridae     Rhinolophidae      Rhipiduridae         Sciuridae 
# 264                90             15952                18               122               126 
# Scolopacidae          Sittidae     Stenostiridae         Strigidae         Sturnidae         Sylviidae 
# 38                53                42               148               317                98 
# Tephrodornithidae     Tettigoniidae        Thraupidae Threskiornithidae        Timaliidae     Troglodytidae 
# 195                40                 3                 1               264                23 
# Trogonidae          Turdidae        Turnicidae         Tytonidae          Upupidae  Vespertilionidae 
# 8               694                 3                 1                32                99 
# Vespidae        Vireonidae      Zosteropidae 
# 5                23               177 
length(unique(ta$family))
# [1] 106
# Catenulaceae is wrong. So, 105 families.
length(unique(ta$genus))
# [1] 231
# Amphora is wrong. So, 230 genera.
# Sort the table in descending order
sorted_table <- sort(table(ta$genus), decreasing = TRUE)
# View the top 10
head(sorted_table, 10)
# Raorchestes     Pycnonotus Trochalopteron     Psilopogon    Rhacophorus         Prinia         Corvus 
# 14794           3502           1198           1000            703            644            587 
# Pitta      Geokichla       Dicrurus 
# 554            545            486 
sorted_table <- sort(table(ta$sci_name), decreasing = TRUE)
head(sorted_table, 10)
# Raorchestes luteolus              Pycnonotus cafer       Raorchestes hassanensis 
# 5570                          3239                          2526 
# Raorchestes tuberohumerus          Raorchestes beddomii           Raorchestes blandus 
# 1879                          1403                          1215 
# Raorchestes jayarami       Trochalopteron lineatum       Raorchestes chlorosomma 
# 1195                          1153                           962 
# Rhacophorus pseudomalabaricus 
# 700 

sort(unique(ta$sci_name))
length(unique(ta$sci_name))

# Count the unique number of species using the speciesKey
# and also check if this is accurate by checking if all the genera, families,
# and orders are represented from the larger data (ta)
species_a <- ta %>%
  distinct(`speciesKey`, .keep_all = TRUE) %>%
  select(speciesKey, sci_name, genus, family, order, class) %>%
  arrange(`sci_name`)

# This shows that Tachyspiza badia which is a synonym for Accipter badius
# appears without a speciesKey as the name is not recognised in GBIF
# So, remove the duplicate
species_a <- species_a %>% 
  filter(!is.na(speciesKey))

# Total number of species
length(unique(species_a$sci_name))
#[1] 368

# Check the actual names
unique(species_a$sci_name)
"insect/ frog" 
# So, the total number of species in Type A is 367 (assuming we haven't missed
# any species at genus level)

length(unique(species_a$genus))
#[1] 221
length(unique(ta$genus))
#[1] 231

# It shows 10 additional genera in the larger dataset. Check what those 10 genera 
# are
setdiff(unique(ta$genus), unique(species_a$genus))
# [1] "Plocealauda"    NA               "Dugong"         "Phaneroptera"   "Eumenes"       
# [6] "Cicada"         "Shinjia"        "Coryphospingus" "Camera"         "Xylocopa"   

# One is NA and another is Camera. They can be ignored. Eight left now. While
# Cicada may not be a species, their family is also not represented by any
# other species. So, these 8 species are new too. But Plocealauda has three species
# in the data - affinis, assamica, and erythroptera. So, 10 left now.

# So, total number of species = 367+10 = 377

# Check any missing family in the unique data
length(unique(species_a$family))
#[1] 93
length(unique(ta$family))
#[1] 106

# So, there are 13 families missing, indicating potential 13 species more. Check
# them 
setdiff(unique(ta$family), unique(species_a$family))
# [1] NA              "Notonectidae"  "Dugongidae"    "Gryllidae"     "Tettigoniidae"
# [6] "Cicadidae"     "Eumenidae"     "Vespidae"      "Aphididae"     "Thraupidae"   
# [11] "Oecanthidae"   "Ichneumonidae" "Apidae"   

# Notonectidae has not been covered by any genera without a speciesKey.
# Oecanthidae could be a synonym for Gryllidae depending on the taxonomy. So,
# only can be considered as a unique species.
# Eumenidae could be a synonym for Vespidae. So, its already covered.

# So, 2 more species. 377+2 = 379

# Check any missing order in the unique data
length(unique(species_a$order))
#[1] 30
length(unique(ta$order))
#[1] 35

# So, there are 5 orders missing, indicating 5 potential species more. Check
# them 
setdiff(unique(ta$order), unique(species_a$order))
# [1] "Hemiptera"   "Sirenia"     "Orthoptera"  "Trichoptera" "Hymenoptera"

# Only Trichoptera is not covered by species, genus, or family stages
#So, 379+1 = 380 species in Type A data

### Type B ####

# A slight detour

# Check the taxonomic distribution of the data (at label level)
table(type_b_sf$rank)
# CLASS     FAMILY       FORM      GENUS    KINGDOM      ORDER    SPECIES SUBSPECIES 
# 13          9          2         95          1         44      27265          6 
# 38 marked at genus level are actually at species level

# Check the number of kingdom, phylum, class, order, family, genus, and species
table(type_b_sf$kingdom)
# Animalia 
# 27435 
table(type_b_sf$phylum)
# Arthropoda   Chordata 
# 77      27357 
table(type_b_sf$class)
# Amphibia     Aves  Insecta Mammalia 
# 60    27220       77       77 
table(type_b_sf$order)
# Accipitriformes     Anseriformes            Anura      Apodiformes     Artiodactyla   Bucerotiformes Caprimulgiformes 
# 132               15               60                3                5              144              181 
# Carnivora  Charadriiformes       Chiroptera    Columbiformes    Coraciiformes     Cuculiformes      Galliformes 
# 3              277               57             2408              254             2524              368 
# Gruiformes        Hemiptera       Orthoptera    Passeriformes   Pelecaniformes       Piciformes Podicipediformes 
# 19                5               70            15100               10             2033                1 
# Primates   Psittaciformes         Rodentia     Strigiformes       Suliformes    Trogoniformes 
# 2             3036               10              679                5                4 
length(unique(type_b_sf$order))
# [1] 28
table(type_b_sf$family)
# Accipitridae    Acrocephalidae      Aegithalidae      Aegithinidae         Alaudidae       Alcedinidae          Anatidae 
# 132               167                 4               403                13               106                15 
# Aphididae          Apodidae          Ardeidae         Artamidae           Bovidae       Bucerotidae        Burhinidae 
# 3                 3                 7                 8                 3               143                44 
# Campephagidae           Canidae     Caprimulgidae   Cercopithecidae        Certhiidae          Cervidae         Cettiidae 
# 197                 1               167                 1                 4                 2                 3 
# Charadriidae     Chloropseidae         Cicadidae      Cisticolidae        Columbidae        Coraciidae          Corvidae 
# 192               162                 1              1138              2408                89              1507 
# Cuculidae         Dicaeidae    Dicroglossidae        Dicruridae    Emballonuridae       Estrildidae           Felidae 
# 2524               345                14              1498                 3                18                 2 
# Gryllidae      Hirundinidae       Hylobatidae          Irenidae         Jacanidae          Laniidae           Laridae 
# 1                 9                 1                 8                 4                41                 3 
# Leiothrichidae     Locustellidae      Megalaimidae      Megapodiidae         Meropidae        Molossidae       Monarchidae 
# 445                 4              1826                 3                59                 1                61 
# Motacillidae      Muscicapidae     Nectariniidae      Notonectidae  Nyctibatrachidae         Oriolidae           Paridae 
# 72              1431              1321                 1                 5              1816               175 
# Passeridae      Pellorneidae Phalacrocoracidae       Phasianidae    Phylloscopidae           Picidae          Pittidae 
# 781                36                 5               365              1019               207                30 
# Ploceidae       Pnoepygidae        Podargidae     Podicipedidae       Psittacidae      Pteropodidae      Pycnonotidae 
# 10                 3                14                 1              3035                 3              1777 
# Rallidae           Ranidae       Ranixalidae  Recurvirostridae     Rhacophoridae      Rhipiduridae         Sciuridae 
# 19                 4                 1                 6                36                97                10 
# Scolopacidae          Sittidae     Stenostiridae         Strigidae         Sturnidae         Sylviidae Tephrodornithidae 
# 26                78                32               671               154                 8                 4 
# Tettigoniidae        Thraupidae Threskiornithidae        Timaliidae        Trogonidae          Turdidae        Turnicidae 
# 64                 2                 3                87                 4                24                 2 
# Tytonidae          Upupidae  Vespertilionidae      Zosteropidae 
# 8                 1                12               108 
length(unique(type_b_sf$family))
# [1] 96
sorted_table <- sort(table(type_b_sf$family), decreasing = TRUE)
head(sorted_table, 10)
# Psittacidae     Cuculidae    Columbidae  Megalaimidae     Oriolidae  Pycnonotidae      Corvidae    Dicruridae  Muscicapidae 
# 3035          2524          2408          1826          1816          1777          1507          1498          1431 
# Nectariniidae 
# 1321 
length(unique(type_b_sf$genus))
# [1] 212
# Sort the table in descending order
sorted_table <- sort(table(type_b_sf$genus), decreasing = TRUE)
# View the top 10
head(sorted_table, 10)
# Psittacula   Spilopelia   Psilopogon      Oriolus   Pycnonotus     Dicrurus      Cuculus Phylloscopus  Dendrocitta     Cinnyris 
# 3017         2346         1826         1816         1771         1498         1310         1010          997          876 
sorted_table <- sort(table(type_b_sf$sci_name), decreasing = TRUE)
head(sorted_table, 10)
# Psittacula cyanocephala      Oriolus xanthornus  Streptopelia chinensis        Pycnonotus cafer      Hierococcyx varius 
# 2298                    1762                    1615                    1599                    1285 
# Dicrurus paradiseus   Psilopogon zeylanicus   Dendrocitta vagabunda      Cinnyris asiaticus      Centropus sinensis 
# 1059                    1034                     989                     852                     795 

length(unique(type_b_sf$sci_name))
#[1] 411

COME BACK TO THIS
unique(type_b_sf$sci_name)

# Count the unique number of species using the speciesKey
# and also check if this is accurate by checking if all the genera, families,
# and orders are represented from the larger data (ta)
species_b <- type_b_sf %>%
  st_drop_geometry() %>%
  distinct(`speciesKey`, .keep_all = TRUE) %>%
  select(speciesKey, sci_name, genus, family, order, class) %>%
  arrange(`sci_name`)

# This shows that Corvus marcorhynchos which is a type for Corvus macrorhychos
# appears without a speciesKey as the name is not recognised in GBIF
# So, remove this row
species_b <- species_b %>% 
  filter(!is.na(speciesKey))

# Total number of species
length(unique(species_b$sci_name))
#[1] 344

# Check the actual names
unique(species_b$sci_name)
# So, the total number of species in Type A is 344 (assuming we haven't missed
# any species at genus level)

length(unique(species_b$genus))
#[1] 202
length(unique(type_b_sf$genus))
#[1] 212

# It shows 10 additional genera in the larger dataset. Check what those 10 genera 
# are
setdiff(unique(type_b_sf$genus), unique(species_b$genus))
# [1] NA               "Plocealauda"    "Seicercus"      "Mecopoda"       "Coryphospingus" "Shinjia"       
# [7] "Tachyspiza"     "Phaneroptera"   "Semnopithecus"  "Indirana"      

# One is NA. They can be ignored. Nine left now. Mirafra (Plocealauda is a synonym) 
# is already present but Plocealauda/Mirafra affinis not present. 
# Phylloscopus nitidus is present and this is a synonym for Seicercus nitidus.
# So, 8 left. Lophospiza trivirgata incorrectly got matched to Coryphospingus. 
# The former is not there. 
# Microtarsus priocephalus incorrectly got matched to Shinjia genus. The former
# is a synonym for Microtarsus priocephalus. That's already there. So, 7 left.
# Tachyspiza (badia) is already present as Accipiter badius. So, 6 left.

# So, these 6 species are new too.

# So, total number of species = 344+6 = 350

# Check any missing family in the unique data
length(unique(species_b$family))
#[1] 89
length(unique(type_b_sf$family))
#[1] 96

# So, there are 7 families missing, indicating potential 7 species more. Check
# them 
setdiff(unique(type_b_sf$family), unique(species_b$family))
# [1] NA                "Thraupidae"      "Aphididae"       "Cercopithecidae" "Gryllidae"      
# [6] "Notonectidae"    "Ranixalidae"  

# Gryllidae and Notonectidae have not been covered by any genera without a speciesKey.

# So, 2 more species. 350+2 = 350

# Check any missing order in the unique data
length(unique(species_b$order))
#[1] 27
length(unique(type_b_sf$order))
#[1] 28

# So, there is one order missing, indicating 1 potential species more. Check
# it
setdiff(unique(type_b_sf$order), unique(species_b$order))
# [1] NA

# That's NA. So, 352 species in total for type B data

### Combined ####

# Combined number of species:
length(union(unique(species_a$sci_name), unique(species_b$sci_name)))
#522

#521 excluding the insect "insect/ frog"

# Check for excluded genera

#From Type A
# [1] "Plocealauda"    NA               "Dugong"         "Phaneroptera"   "Eumenes"       
# [6] "Cicada"         "Shinjia"        "Coryphospingus" "Camera"         "Xylocopa"   
#From Type B
# [1] NA               "Plocealauda"    "Seicercus"      "Mecopoda"       "Coryphospingus" "Shinjia"       
# [7] "Tachyspiza"     "Phaneroptera"   "Semnopithecus"  "Indirana" 

#Excluding NA and Camera in both Type A+B. Mirafra (Plocealauda is a synonym) 
# has three species between type A and B. Coryphospingus (referring actually
# to Lophospiza trivirgata), Shinjia (referring actually to Microtarsus 
# priocephalus), and Phaneroptera are common between A and B. So, 13 unique
# species in addition.

# i.e. 521+13 = 533

# Check for excluded families

# From Type A
# [1] NA              "Notonectidae"  "Dugongidae"    "Gryllidae"     "Tettigoniidae"
# [6] "Cicadidae"     "Eumenidae"     "Vespidae"      "Aphididae"     "Thraupidae"   
# [11] "Oecanthidae"   "Ichneumonidae" "Apidae"
# From Type B
# [1] NA                "Thraupidae"      "Aphididae"       "Cercopithecidae" "Gryllidae"      
# [6] "Notonectidae"    "Ranixalidae"  

# Exclude NA
# Notonectidae has not been covered by any genera without a speciesKey in both Type A+B.
# Oecanthidae could be a synonym for Gryllidae depending on the taxonomy. So,
# only one can be considered as a unique species. So, two additional species.

# i.e. 533+2 = 535

# Check for excluded orders

# For Type A
# [1] "Hemiptera"   "Sirenia"     "Orthoptera"  "Trichoptera" "Hymenoptera"
# For Type B
# [1] NA

# Only Trichoptera is not covered by species, genus, or family stages

#So, 535+1 = 536 species in both Type A and Type B data combined
