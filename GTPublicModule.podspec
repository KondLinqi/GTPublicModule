Pod::Spec.new do |s|
  s.name             = 'GTPublicModule'
  s.version          = '0.1.0'
  s.summary          = 'GTPublicModule 的公共模块，包括公共方法，宏，拓展等'
  s.homepage         = 'https://github.com/liuxc123/GTPublicModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/GTPublicModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.requires_arc = true

  # 源代码
  s.source_files = 'GTPublicModule/**/*'

  # 配置系统Framework
  s.frameworks = 'UIKit', 'Foundation'

  
  s.public_header_files = 'LDBusMediator/LDBusConnectorPrt.h','LDBusMediator/LDBusMediator.h', 'LDBusMediator/LDBusNavigator.h', 'LDBusMediator/UIViewController+NavigationTip.h'


end
