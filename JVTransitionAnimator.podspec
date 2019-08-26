#
# Be sure to run `pod lib lint JVTransitionAnimator.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "JVTransitionAnimator"
  s.version          = "1.0"
  s.summary          = "JVTransitionAnimator to animatem your view controllers."
  s.description      = "A simple transition animator that allows to present View Controller in a pretty cool way."
  s.homepage         = "https://github.com/JV17/JVTransitionAnimator"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jorge Valbuena" => "jorgevalbuena2@gmail.com" }
  s.source           = { :git => "https://github.com/JV17/JVTransitionAnimator.git", :tag => s.version.to_s }
  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
