module Validations

	def is_i?(x)#to check feild require numbers only
		if(x =~ /[a-z|A-Z|!|@|#|$|%|^|&|*|(|)|_]/) 
			return false
		end
		return true#no detected
	end
	
	def is_a?(x)#to check feild require charecters only		
		if(x =~ /[0-9]/) 
			return false#no found
		end
		if(x =~ /[!|#|$|%|^|&|*|(|)|;|:|'|\|"|@|}|{]/) #charectars not allowed in username
			return false
		end

		return true#charecters only
	end
	
	def username(x)
		if(x =~ /[!|#|$|%|^|&|*|(|)|;|:|'|\|"]/) #charectars not allowed in username
			return false
		end
		if((x =~ /^[a-z|A-Z]/) == nil) #/^[a-z|A-Z]/ returns nil if not starting with alphabates only 
			return false
		end
		
		return true
	end
	
	def valid_date(x)
		a=x.split('/')
		t=a[0].to_i	
		t1=a[1].to_i
		t2=a[2].to_i
		if ((0 < t) && (t <= 31) && (0 < t1) && (t1 <= 12) && (1950 <= t2) && (t2 <= 2013))
			return true
		else
			return false
		end			
	end
	
	def password(x)
		if x.length < 6
			return false
		else
			return true
		end
	end
	
	def repeate_projectname(x)
	if (File.exist?("project.info"))
	fin=File.open("project.info","r")	
	project_info=fin.read.split(" ")
	fin.close
	len=project_info.length

	for i in 0...project_info.length
	#puts project_info[i]
	
	case project_info[i]
		when "#PROJECT_NAME"
			if(project_info[i+1]==x)
				#puts "project already exists"
				return false			
			end	
		end
	end	#for ends
	return true
	end#if ends
	
	end#def ends
	
	def repeate_username(x)

	if (File.exist?("project.info"))
	fin=File.open("project.info","r")	
	project_info=fin.read.split(" ")
	fin.close
	len=project_info.length

	for i in 0...project_info.length
	
	case project_info[i]
		when "#USER_NAME"
			if(project_info[i+1]==x)
				#puts "project already exists"
				return false			
			end	
		end
	end	#for ends
	return true
	end#if ends
	
	end#def ends

end
