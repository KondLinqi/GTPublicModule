Pod::Spec.new do |s|
  s.name             = 'GTPublicModule'
  s.version          = '0.0.1'
  s.summary          = 'GTPublicModule 的公共模块，包括公共方法，宏，拓展等'
  s.homepage         = 'https://github.com/liuxc123/GTPublicModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/GTPublicModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.frameworks       = 'Foundation', 'UIKit'

  s.requires_arc = true

s.source_files = 'GTPublicModule/GTPublicModule.h',
'GTPublicModule/GTCategory/GTCategory.h',
'GTPublicModule/GTCategory/Foudation/**/*.*',
'GTPublicModule/GTCategory/UIKit/**/*.*',
'GTPublicModule/GTCategory/QuartzCore/**/*.*',
'GTPublicModule/GTCategory/CoreLocation/**/*.*',
'GTPublicModule/GTCategory/MapKit/**/*.*',
'GTPublicModule/GTMacros/*.*',
'GTPublicModule/GTPublicTool/**/*.*'





end
