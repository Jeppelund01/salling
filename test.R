#get data
baseurl="https://api.sallinggroup.com/v1/food-waste/?zip="
zip="3450"
fullurl=paste0(baseurl,zip)
mytoken='SG_APIM_76MCVAWZZSB0423GN2FE25FWNMYAXV4JB5AMTQD6EJERP8XD4E20'

res=GET(url=fullurl, add_headers(
  Authorization = paste('Bearer',mytoken)
))

res$status_code
resraw=content(res, as='text')
resraw2=fromJSON(resraw, flatten = T)

resraw2 <- resraw2 %>% 
  select(-store.hours, -store.type, -store.address.extra, -store.address.country)



netto_allerød=resraw2$clearances[[1]]
netto_blovstrød=resraw2$clearances[[2]]
netto_stationsvej=resraw2$clearances[[3]]

store.id <- resraw2$`store.id`[3]   # vælg butik nr. 1
netto_stationsvej$store.id  <- store.id  # samme ID i alle rækker

netto_stationsvej <- netto_stationsvej[, c("store.id", setdiff(names(netto_stationsvej), "store.id"))]


netto_allerød <- netto_allerød %>%
  select(-product.categories.da,
         -offer.currency,
         -offer.stockUnit,
         -offer.ean)



foodwaste_all <- bind_rows(
  netto_allerød,
  netto_blovstrød,
  netto_stationsvej
)


