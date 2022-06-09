#macro csv_load_auto_reload			true	//文件变动自动重载
#macro csv_load_show_debug_message	true	//加载时输出解析后的struct
/*
=================================================================
	csv结构 v0.1
					-- by yunzl
=================================================================

	csv_load(f):struct		返回csv结构
		f		:	文件路径,csv文件必须是utf8编码
		
	例子
		csv=csv_load("C:/1.csv")
		str=csv.get("A1")

=================================================================

	成员
  -------------------------------------------------------------  
  
		load():undefined	加载csv文件
		
  -------------------------------------------------------------  

		get(xx,yy):str		返回相应坐标的内容,取空返回""
			xx,yy	:	坐标
			
			例子
				csv.get("B2")
				csv.get(2,2)
				csv.get("uid","sun")
				
  -------------------------------------------------------------  

		get_row(yy):struct	返回对应行的内容
			yy		:	如果输入数字,则返回数字排序的行内容
	
			例子
				csv.get_row(1)			//{ 0 : "uid", 1 : "str", 2 : "str2", 3 : undefined, 4 : undefined }
				csv.get_row("11")		//{ uid : "11", str2 : "321", str : "123" }
				csv.get_row("33").str	//hhh
		
			
=================================================================

	变量
  -------------------------------------------------------------  
		path		:	csv路径
		data		:	储存csv解析后的struct
		data_head	:	储存横竖标头的struct
		width		:	宽
		height		:	高

=================================================================
*/

function csv_load(f/*fileName*/){
	var csv=function(f)constructor{
		path=f
		
		//保存csv的struct数据
		data={}
		
		//横竖头标
		data_head_w={}
		data_head_h={}
		
		//数据宽高
		width=0
		height=0
		
		//计时器
		time_source=undefined
		
		//数字转csv坐标
		num_to_abc=function(num){
			var str=""
			static ansi=[
				"A","B","C","D","E","F","G",
				"H","I","J","K","L","M","N",
				"O","P","Q","R","S","T",
				"U","V","W","X","Y","Z"
			]
			while(num>0){
				var m=num%26
				if m==0 m=26
				str=ansi[m-1]+str
				num=(num-m)div 26
			}
			return str
		}
		
		//动态转换为excel坐标
		pos_to_a1=function(xx,yy){
			if is_real(xx) and is_real(yy){
				xx=num_to_abc(xx)+string(yy)
				yy=undefined
			}
			if is_real(xx) xx=num_to_abc(xx)
			if is_real(yy) yy=string(yy)
			
			if yy!=undefined{
				
				var t=data_head_w[$xx]
				if t!=undefined xx=string(t)
				
				var t=data_head_h[$yy]
				if t!=undefined yy=string(t)
				
				xx=xx+yy
			}
			return string_upper(xx)
		}
		//销毁计时器
		ts_destroy=function(){
			try{
				if time_source!=undefined{
					time_source_destroy(time_source)
				}
			}
		}
		
		//加载文件
		load=function(){
			//检测文件是否存在
			if !file_exists(path){
				show_debug_message("no file:"+path)
				return 0
			}
			//用于对比
			md5=md5_file(path)
			
			ds=load_csv(path)
			data={}//清空data
			data_head_w={}//清空头标
			data_head_h={}//清空头标
			
			//将ds解析到struct
			var w = ds_grid_width(ds);
			var h = ds_grid_height(ds);
			width=w
			height=h
			
			//清理utf8的bom头
			if w and h{
				str=ds[#0,0]
				if ord(string_copy(str,1,1))==65279{
					ds[#0,0]=string_delete(str,1,1)
				}
			}
			
			//将内容转输入到data
			for (var i = 0; i < w; i++;){for (var j = 0; j < h; j++;){
				var str=ds[# i,j ]
				if string_length(str){
					data[$ num_to_abc(i+1) + string(j+1) ]	=	str
					//将第一行和第一列的内容做索引
					if j=0 if data_head_w[$str]==undefined data_head_w[$str]=num_to_abc(i+1)
					if i=0 if data_head_h[$str]==undefined data_head_h[$str]=j+1
				}
			}}
			ds_grid_destroy(ds)
			
			if csv_load_show_debug_message {
				show_debug_message(data)
				show_debug_message(data_head_w)
				show_debug_message(data_head_h)
			}
			
			return 1
		}
		
		//坐标取内容
		get=function(xx,yy){
			return data[$pos_to_a1(xx,yy)]
		}
		
		//取行内容
		get_row=function(yy){
			var st={}
			if is_real(yy){
				for(i=0;i<width;i++){
					st[$i]=get(i+1,yy)
				}
			}else{
				for(i=0;i<width;i++){
					var key=get(i+1,1)
					if key!=undefined{
						st[$key]=get(key,yy)
					}
				}
			}
			

			return st
		}
		
		//加载
		if load(){
		
			//监听文件重加载
			if csv_load_auto_reload{
				
				try{//可能旧版本不存在这个函数
					time_source=time_source_create(1,3,0,function(){
						if md5!=md5_file(path) load()
					},[],-1)
					time_source_start(time_source)
				}

			}
			
		}
		
		
		
	}
	return new csv(f)
}