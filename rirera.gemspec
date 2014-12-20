Gem::Specification.new do |s|
  s.name                    = 'rirera'
  s.version                 = '0.1.4'
  s.date                    = Time.now.strftime('%Y-%m-%d')
  s.summary                 = "Risk Reward Ratio"
  s.description             = "A simple Risk Reward Ratio calculator"
  s.authors                 = ["Maximilian Meister"]
  s.email                   = 'mmeister@suse.de'
  s.rubyforge_project       = 'rirera'
  s.files                   = `git ls-files`.split("\n")
  s.executables             = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.bindir                  = 'bin'
  s.require_paths           = ["lib"]
  s.homepage                = 'http://github.com/MaximilianMeister/rirera'
  s.license                 = 'MIT'
  s.post_install_message    = 'Happy trading!'
end
