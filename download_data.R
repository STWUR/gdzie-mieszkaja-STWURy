library(RGoogleAnalytics)
load("./token_file")
query.init <- Init(start.date = "2017-01-01",
                   end.date = "2017-03-18",
                   dimensions = c("ga:date", "ga:country", "ga:region", "ga:city"),
                   metrics = c("ga:sessions", "ga:users", "ga:newUsers"),
                   max.results = 10000,
                   table.id = "ga:138279144")

query <- QueryBuilder(query.init)
write.csv(GetReportData(query, token), "STWURy.csv", row.names = FALSE)
