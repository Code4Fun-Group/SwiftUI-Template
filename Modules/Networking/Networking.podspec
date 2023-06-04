Pod::Spec.new do |spec|
	spec.name         = "Networking"
	spec.version      = "1.0.0"
	spec.summary      = "Networking Framework"
	spec.description  = <<-DESC
	Networking
	DESC
	
	spec.homepage     = "https://www.code4fun.group"
	spec.license      = { :type => 'MIT', :file => 'LICENSE' }
	spec.author       = { "Max Nguyen" => "max.nguyen@techvify.com.vn" }
	spec.ios.deployment_target = "13.0"
	
	spec.source       = { :git => "http://git.techvify.com.vn/internal/poc/iOS/Networking.git", :tag => spec.version.to_s }
	spec.source_files = 'Sources/Networking/**/*.{swift,h}'
	
	spec.dependency 'Common'
	spec.dependency 'Alamofire'
end

