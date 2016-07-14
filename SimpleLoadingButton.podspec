@version = "0.1.0"
Pod::Spec.new do |s|
s.name                    = 'SimpleLoadingButton'
s.version                 = @version
s.license                 = { :type => 'MIT', :file => 'LICENSE' }
s.summary                 = 'Simple button with loading animation'
s.homepage                = 'https://github.com/mruvim/SimpleLoadingButton'
s.authors                 = { 'Ruvim Miksanskiy' => 'ruva@codingroup.com' }
s.source                  = { :git => 'https://github.com/mruvim/SimpleLoadingButton.git', :tag => s.version.to_s }
s.platform                = :ios, "8.0"
s.requires_arc            = true

s.ios.deployment_target   = '8.0'
s.source_files            = 'SimpleLoadingButton/**/*.swift'
end