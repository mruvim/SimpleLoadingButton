Pod::Spec.new do |s|

s.name                    = "SimpleLoadingButton"
s.version                 = "0.3"
s.license                 = { :type => "MIT", :file => "LICENSE"}

s.homepage                = "https://github.com/mruvim/SimpleLoadingButton"
s.summary                 = "Simple button with loading animation"
s.author                  = { "Ruvim Miksanskiy" => "ruva@codingroup.com" }
s.source                  = { :git => "https://github.com/mruvim/SimpleLoadingButton.git", :tag => s.version, :branch => "master"}

s.screenshot              = "http://codingroup.com/assets/external/button.gif"

s.platform                = :ios, "9.0"
s.requires_arc            = true

s.ios.deployment_target   = "9.0"
s.source_files            = "SimpleLoadingButton/**/*.swift"

end

