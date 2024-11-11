local mapArray = MEMapArray:new()
mapArray:push({ id = 1, target_count = 10, reward = "1_30135_2", next_count = 20})
mapArray:push({ id = 2, target_count = 20, reward = "1_30038_1", next_count = 50})
mapArray:push({ id = 3, target_count = 50, reward = "1_40318_1", next_count = 100})
mapArray:push({ id = 4, target_count = 100, reward = "1_35077_5", next_count = 150})
mapArray:push({ id = 5, target_count = 150, reward = "1_30038_1", next_count = 200})
mapArray:push({ id = 6, target_count = 200, reward = "1_9006_1", next_count = 0})
return mapArray