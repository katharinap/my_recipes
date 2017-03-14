require File.expand_path("../../test_helper", __FILE__)

class BootstrapFlashHelperTest < ActionView::TestCase
  setup do
    flash = {notice: ["This is a succesful message"],
              alert: ["This is an info message"],
              error: ["This is an error message", "Another error message", ""],
              invalid: ["some invalid type"]
    }
    stubs(:flash).returns(flash)
    @result = bootstrap_flash(class: 'flash').to_str
  end

  context "bootstrap_flash" do
    should "handle :notice type" do
      expected_result =
          "<div class=\"alert fade in alert-info flash\"><button class=\"close\" data-dismiss=\"alert\">&times;</button>This is a succesful message</div>"
      assert @result.include? expected_result
    end

    should 'handle :alert type' do
      expected_result =
          "<div class=\"alert fade in alert-danger flash\"><button class=\"close\" data-dismiss=\"alert\">&times;</button>This is an info message</div>"
      assert @result.include? expected_result
    end

    should 'handle :error type' do
      expected_error_1 =
          "<div class=\"alert fade in alert-danger flash\"><button class=\"close\" data-dismiss=\"alert\">&times;</button>This is an error message</div>"
      expected_error_2 =
          "<div class=\"alert fade in alert-danger flash\"><button class=\"close\" data-dismiss=\"alert\">&times;</button>Another error message</div>"
      assert @result.include? expected_error_1
      assert @result.include? expected_error_2
    end

    should "ignore invalid types" do
      refute  @result.include? "some invalid type"
    end
  end
end
