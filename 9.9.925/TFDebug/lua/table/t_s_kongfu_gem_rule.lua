local mapArray = MEMapArray:new()

mapArray:push({ slot_id = 1, gem_same = "1_5000", gem_diff = "2_3000", unlock = "1_1", max_level = 150})
mapArray:push({ slot_id = 2, gem_same = "2_5000", gem_diff = "3_3000", unlock = "1_10", max_level = 150})
mapArray:push({ slot_id = 3, gem_same = "3_5000", gem_diff = "4_3000", unlock = "2_10", max_level = 150})
mapArray:push({ slot_id = 4, gem_same = "4_5000", gem_diff = "5_3000", unlock = "3_10", max_level = 150})
mapArray:push({ slot_id = 5, gem_same = "5_5000", gem_diff = "1_3000", unlock = "4_10", max_level = 150})
return mapArray
