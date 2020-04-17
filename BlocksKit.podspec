Pod::Spec.new do |s|
  s.name                  = 'BlocksKit'
  s.version               = '2.2.6.3-mirego'
  s.license               = 'MIT'
  s.summary               = 'The Objective-C block utilities you always wish you had.'
  s.homepage              = 'https://zwaldowski.github.io/BlocksKit'
  s.author                = { 'Zachary Waldowski' => 'zach@waldowski.me',
                              'Alexsander Akers'  => 'a2@pnd.mn' }
  s.source                = { :git => 'https://github.com/mirego/BlocksKit.git', :tag => "v#{s.version}" }
  s.requires_arc          = true

  s.osx.deployment_target = '10.8'
  s.ios.deployment_target = '6.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.default_subspec = 'Core', 'DynamicDelegate', 'MessageUI', 'QuickLook', 'UIKit'

  s.subspec 'Core' do |ss|
    ss.osx.deployment_target = '10.8'
    ss.ios.deployment_target = '6.0'
    ss.watchos.deployment_target = '2.0'
    ss.tvos.deployment_target = '9.0'

    ss.source_files = 'BlocksKit/BlocksKit.h', 'BlocksKit/BKDefines.h', 'BlocksKit/Core/*.{h,m}'
  end

  s.subspec 'DynamicDelegate' do |ss|
    ss.osx.deployment_target = '10.8'
    ss.ios.deployment_target = '6.0'
    ss.tvos.deployment_target = '9.0'

    ss.dependency 'BlocksKit/Core'
    ss.source_files = 'BlocksKit/DynamicDelegate/*.{h,m}', 'BlocksKit/DynamicDelegate/Foundation/*.{h,m}'
  end

  s.subspec 'MessageUI' do |ss|
    ss.ios.deployment_target = '6.0'

    ss.dependency 'BlocksKit/Core'
    ss.dependency 'BlocksKit/DynamicDelegate'
    ss.source_files = 'BlocksKit/BlocksKit+MessageUI.h', 'BlocksKit/MessageUI/*.{h,m}'
    ss.frameworks = 'MessageUI'
  end

  s.subspec 'QuickLook' do |ss|
    ss.ios.deployment_target = '6.0'

    ss.dependency 'BlocksKit/Core'
    ss.dependency 'BlocksKit/DynamicDelegate'
    ss.source_files = 'BlocksKit/BlocksKit+QuickLook.h', 'BlocksKit/QuickLook/*.{h,m}'
    ss.frameworks = 'QuickLook'
  end

  s.subspec 'UIKit' do |ss|
    ss.ios.deployment_target = '6.0'
    ss.tvos.deployment_target = '9.0'

    ss.dependency 'BlocksKit/Core'
    ss.dependency 'BlocksKit/DynamicDelegate'
    ss.source_files = 'BlocksKit/BlocksKit+UIKit.h', 'BlocksKit/UIKit/*.{h,m}'
  end
end
