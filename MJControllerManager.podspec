#
# Be sure to run `pod lib lint MJControllerManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MJControllerManager"
  s.version          = "0.1.4"
  s.summary          = "This module contain base class of view controller and some common use function."

  s.homepage         = "https://github.com/Musjoy/MJControllerManager"
  s.license          = 'MIT'
  s.author           = { "Raymond" => "Ray.musjoy@gmail.com" }
  s.source           = { :git => "https://github.com/Musjoy/MJControllerManager.git", :tag => "v-#{s.version}" }

  s.ios.deployment_target = '7.0'

  s.source_files = 'MJControllerManager/Classes/**/*'

  s.user_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'MODULE_CONTROLLER_MANAGER'
  }

  s.dependency 'ActionProtocol'
  s.dependency 'ModuleCapability', '~> 0.1.2'
  s.prefix_header_contents = '#import "ModuleCapability.h"'

end
