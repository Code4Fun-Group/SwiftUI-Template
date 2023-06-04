Pod::Spec.new do |spec|
  spec.name         = "Common"
  spec.version      = "1.0.0"
  spec.summary      = "Common Framework"
  spec.description  = <<-DESC
	Common	
DESC

  spec.homepage     = "https://www.code4fun.group"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
	spec.author       = { "Max Nguyen" => "max.nguyen@techvify.com.vn" }
  spec.ios.deployment_target = "13.0"

  spec.source       = { :git => "http://git.techvify.com.vn/internal/poc/iOS/Common.git", :tag => spec.version.to_s }
  spec.source_files = 'Sources/Common/**/*.{swift,h}'
  spec.dependency 'KeychainAccess'
end
