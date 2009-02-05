require 'test/unit'

require 'gettext'
require 'testlib/multi_textdomain.rb'

class TestGetTextMulti < Test::Unit::TestCase
  def setup
    GetText.locale = "ja_JP.EUC-JP"
  end

  def test_two_domains_in_a_class
    test = C11.new
    assert_equal("japanese", test.test)  # Use test1.po
    assert_equal("JAPANESE", test.test2) # Use test2.po

    test = C12.new
    assert_equal("japanese", test.test)  # Use test1.po
    assert_equal("JAPANESE", test.test2) # Use test2.po
  end

  def test_inheritance
    # inheritance. only parent has a textdomain and it's methods
    test = C21.new
    assert_equal("japanese", test.test)   # Use C11's po(test1.po)
    assert_equal("JAPANESE", test.test2)  # Use C11's po(test2.po)

    test = C22.new
    assert_equal("japanese", test.test)   # Use C11's po(test1.po)
    assert_equal("JAPANESE", test.test2)  # Use C11's po(test2.po)
  end

  def test_module_and_sub_modules
    # module
    assert_equal("japanese", M1.test)

    # sub-module. only an included module has a textdomain and it's methods
    assert_equal("japanese", M1::M1M1.test)   # Same method with M1.
    assert_equal("LANGUAGE", M1::M1M1.test2)  # No influence from ancestors.

     # sub-class (class bindtextdomain).
    test = M1::M1C1.new
    assert_equal("japanese", test.test)   # Use test1.po
    assert_equal("JAPANESE", test.test2)  # Use test2.po

   # sub-class (instance bindtextdomain).
    test = M1::M1C2.new
    assert_equal("japanese", test.test)   # Use test1.po
    assert_equal("JAPANESE", test.test2)  # Use test2.po
  end

  def test_eval
    test = C2.new
    assert_equal("japanese", test.test)   # Use test1.po
  end

  def test_as_class_methods
    test = C3.new
    assert_equal("japanese", test.test)   # Use test1.po
    assert_equal("japanese", C3.test)     # Use test1.po
  end

  def test_simple_inheritance
    test = C4.new
    assert_equal("japanese", test.test)   # Use C3's test1.po
    assert_equal("japanese", C4.test)     # Use C3's test1.po
    assert_equal("JAPANESE", test.test2)  # Use C4's test2.po
    assert_equal("no data", test.test3)   # No po file.
  end


end