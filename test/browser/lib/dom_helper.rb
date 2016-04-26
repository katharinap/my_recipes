module BrowserTests
  module DomHelper

    def confirm_with(response=:ok)
      raise "Must be running with a javascript driver. Driver: #{Capybara.current_driver}" unless Capybara.current_driver == Capybara.javascript_driver
      raise ArgumentError.new("Must call with :ok or :cancel") unless [:ok, :cancel].include?(response)

      case Capybara.current_driver
        when :selenium
          yield
          alert_method =
              case response
                when :ok then
                  :accept
                when :cancel then
                  :dismiss
              end
          page.driver.browser.switch_to.alert.send(alert_method)
        else # e.g. :webkit
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
    end

    def require_javascript_driver!
      Capybara.current_driver = Capybara.javascript_driver
    end

    def reset_capybara_driver
      Capybara.use_default_driver
    end
  end
end
