require 'rack'
require 'rack/test'
require 'babysms/web_application'
require 'active_support/core_ext/string/inflections'

RSpec.shared_context 'as a WebHook' do
  def load_example(example_name)
    subject_directory = subject.class.name.split('::').last.underscore
    example_directory = File.join(File.dirname(__FILE__), "../examples", subject_directory)
    example_file = Dir.glob(File.join(example_directory, "#{example_name}.*")).first
    File.read(example_file)
  end
end
