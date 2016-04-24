require 'monadt'

module Monadt
  class AsyncEitherExample
    @@urls = {
      "www.test.com" => {hello: 'world'},
      "www.another.com/world" => {get: 'data'},
      "www.test.com/data" => {bar: 'baz'}
    }
    class << self

      def get_url(x)
        Fiber.new {
          sleep 0.01
          if @@urls.has_key? x
            Either.right @@urls[x]
          else
            Either.left "URL #{x} could not be retrieved"
          end
        }
      end

      def async_func_works()
        Monad.async do |m|
          test = m.bind (get_url "www.test.com")
          binding.pry
          another = m.bind (get_url "www.another.com/#{test[:hello]}")
          data = m.bind (get_url "www.test.com/#{another[:get]}")
          m.return data
        end
      end

      def async_func_short_circuit()
        Monad.async_either do |m|
          test = m.bind (get_url "www.test.com")
          binding.pry
          another = m.bind (get_url "www.fail.com/#{test[:hello]}")
          raise "NO"
          data = m.bind (get_url "www.test.com/#{another[:get]}")
          m.return data
        end
      end
    end
  end
end
