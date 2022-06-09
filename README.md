# csv_load

对csv文件进行包装
![](https://s3.bmp.ovh/imgs/2022/06/09/bfc140c66881bae9.png)

# 第一步
````c++
csv=csv_load("1.csv")//加载csv
````

# 宏

````c++
//不需要调试了的话建议全关掉
#macro csv_load_auto_reload		true	//文件变动自动重载
#macro csv_load_show_debug_message	true	//加载时输出解析后的struct
````

#函数

````c++
load()//读取文件,如果你希望手动重载一下的话
````

````c++
get(x,y)//返回某个横竖坐标上格子的内容

//比较特殊的是该函数支持混合转义
csv.get("A1")           //直接填写excel坐标
csv.get(1,1)            //还是表示A1
csv.get("name","name")  //还是A1
csv.get("age","丹霞")   //C4
````


````c++
get_row(y)//返回整行内容

//填写行号与头字符串返回的内容也有区别
csv.get_row(4)      //{ 0 : "丹霞", 1 : "303", 2 : "16", 3 : "地理" }
csv.get_row("丹霞") //{ name : "丹霞", form : "地理", uid : "303", age : "16" }
````
跟你没什么关系的东西
````c++
num_to_abc(num)//将数字转换成a到z排序的excel坐标
````

````c++
pos_to_a1(x,y)//将坐标转换成excel坐标
````
````c++
ts_destroy()//销毁重载计时器
````

# 变量
````c++
path    //该结构的csv文件路径
data    //储存表格数据的结构
data_head_w //横表头映射
data_head_h //纵表头映射
time_source //用来储存重载脚本的计时器id
````
