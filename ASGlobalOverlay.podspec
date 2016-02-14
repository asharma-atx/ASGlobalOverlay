
Pod::Spec.new do |s|
  s.name             = "ASGlobalOverlay"
  s.version          = "1.0.0"
  s.summary          = "A modern pop-over controller thats easy to implement."
  s.description      = <<-DESC

  ASGlobalOverlay is a pop-over controller that can display alerts, slide-up menus, and is-working indicators on top of your app. It features a modern interface and easy implementation. Check out the README for details.

                       DESC

  s.homepage         = "https://github.com/asharma-atx/ASGlobalOverlay"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2" will plug in once uploaded
  s.license          = 'MIT'
  s.author           = { "Amit Sharma" => "amitsharma@mac.com" }
  s.source           = { :git => "https://github.com/asharma-atx/ASGlobalOverlay.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/Global\ Overlay/*.h', 'Pod/Classes/User\ Option/*.h'
  s.resource_bundles = {
    'ASGlobalOverlay' => ['Pod/Assets/*.png']
  }

end
