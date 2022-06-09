csv=csv_load("1.csv")

show_debug_message("========")


str=csv.get("a1")
show_debug_message(str)

str=csv.get("A",2)
show_debug_message(str)

str=csv.get(4,3)
show_debug_message(str)

str=csv.get("age","丹霞")
show_debug_message(str)

st=csv.get_row("丹霞")
show_debug_message(st)

st=csv.get_row(4)
show_debug_message(st)

show_debug_message("========")
