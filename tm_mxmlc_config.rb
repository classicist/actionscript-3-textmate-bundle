def get_mxmlc_args(env, tm_project_dir)
  @cvsbranch = cvsbranch(tm_project_dir)
  mxmlc_args = {:main => "-o=#{path_to_java_project}/com.clickfox.servlet/WebContent/cfportal.swf -file-specs=src/main/flex/cfportal.mxml  #{main_library_paths}",
                :unit => "-o=#{path_to_java_project}/com.clickfox.servlet/WebContent/cfportal.swf -file-specs=src/test/flex/org/ironcity/VisualAllTestsRunner.mxml  #{test_library_paths} #{main_library_paths}",
                :integration => "-o=#{path_to_java_project}/com.clickfox.servlet/WebContent/cfportal.swf -file-specs=src/test/flex/org/ironcity/integration/VisualAllIntegrationTestsRunner.mxml  #{test_library_paths} #{main_library_paths}"}

  prepare_and_print(mxmlc_args[env.to_sym], tm_project_dir)
end

def get_acceptance_args(tm_project_dir)
  acceptance_args = "#{funfx_automation_paths}"
  prepare_and_print(acceptance_args, tm_project_dir)
end

def add_dir_path(mxmlc_args, tm_project_dir)
  mxmlc_args.split(" ").map do |arg| 
    if has_element_in_need_of_path(arg)
      arg.gsub(mxmlc_argument_format, '\1' + '\2' + "#{tm_project_dir}/" + '\3')
    else
      arg
    end
  end.join(" ")
end

def prepare_and_print(args, tm_project_dir)
  tm_project_dir += "/cfportal"
  args = add_dir_path(args, tm_project_dir)
  $stdout << (args || "sorry, #{env} is not a valid environment, try #{mxmlc_args.keys.to_s}")
end

def has_element_in_need_of_path(arg)
  ["-o", "-file-specs", "-sp", "-library-path", "-include-libraries"].each {|correct_element| return true if arg.include?(correct_element) && !( is_an_absolute_path(arg) ) }
  false
end

def mxmlc_argument_format
  /^(\-.+?)(\+\=|\=)(.*)$/
end

def is_an_absolute_path(arg)
  path = arg.gsub(mxmlc_argument_format, '\3')
  path =~ /^\/.*$/
end

def main_library_paths
  "-library-path+=src/main/flex/lib/ -sp+=src/main/flex/ -locale=en_US -sp+=src/main/locale/"
end

def test_library_paths
  "-library-path+=src/test/flex/lib/ -sp+=src/test/flex/"
end

def funfx_automation_paths
  "-include-libraries+=src/test/flex/lib/funfx-0.2.2.swc -include-libraries+=#{path_to_sdk}/frameworks/libs/automation.swc -include-libraries+=#{path_to_sdk}/frameworks/libs/automation_agent.swc -include-libraries+=#{path_to_sdk}/frameworks/libs/automation_dmv.swc -include-libraries+=#{path_to_sdk}/frameworks/locale/en_US/automation_agent_rb.swc"
end

def path_to_java_project
  "/Users/monster/Development/elipse_workspaces/Java/#{@cvsbranch}"
end

def path_to_sdk
  "/Users/monster/bin/flex_builder_sdk"
end

def cvsbranch(tm_project_dir)
  @cvsbranch = tm_project_dir.split("/").last
end

#puts get_mxmlc_args("unit", '/Users/monster/Development/elipse_workspaces/Flex/2009_C5_BPDEMO')
#puts get_acceptance_args('MOO')