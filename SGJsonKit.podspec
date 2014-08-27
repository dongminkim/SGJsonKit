Pod::Spec.new do |s|

  s.name         = "SGJsonKit"
  s.version      = "1.1"
  s.license      = "MIT"

  s.summary      = "Auto-mapping json objects to Objective-C classes"
  s.description  = <<-DESC
                   * Purpose
				    * Auto-mapping json objects to Objective-C classes
				    * Generate JSON from Objective-C classes
                   * Requirements
				    * iOS v5.0 and later
					* Mac OS X v10.7 and later
				   DESC
  s.homepage     = "http://github.com/dongminkim/SGJsonKit"
  s.author       = { "Dongmin Kim" => "dongmin.kim@gmail.com" }

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"

  s.source       = { :git => "https://github.com/dongminkim/SGJsonKit.git", :tag => "v1.1" }
  s.source_files  = "SGJsonKit/*.{h,m}", "SGJsonKit/NumberArray/*.{h,m}"

  s.requires_arc = true

end
