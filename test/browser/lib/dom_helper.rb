module BrowserTests
  module DomHelper

    def confirm_with(response=:ok)
      raise "Must be running with a javascript driver. Driver: #{Capybara.current_driver}" unless Capybara.current_driver == Capybara.javascript_driver
      raise ArgumentError.new("Must call with :ok or :cancel") unless [:ok, :cancel].include?(response)

      begin
        page.evaluate_script <<-js
        window.original_confirm = window.confirm;
        window.confirm = function(str) { return true };
        js
        yield
      ensure
        page.evaluate_script <<-js
        window.confirm = window.original_confirm;
        js
      end
    end

    def require_javascript_driver!
      Capybara.current_driver = Capybara.javascript_driver
    end

    def reset_capybara_driver
      Capybara.use_default_driver
    end
  end
end
