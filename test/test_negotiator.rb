$VERBOSE = true
require 'test/unit'
require 'fileutils'

require '../negotiator/lib/negotiator'

class TestNegotiator < Test::Unit::TestCase
  def test_any
    h = "*/*"
    a = {"text/plain" => 1.0, "application/json" => 0.9999, "text/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("text/plain", t)
  end

  def test_subsume_any
    h = "text/plain, */*"
    a = {"text/plain" => 1.0, "application/json" => 0.9999, "text/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("text/plain", t)
  end

  def test_part
    h = "text/*"
    a = {"text/plain" => 1.0, "application/json" => 0.9999, "text/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("text/plain", t)
  end

  def test_subsume_part
    h = "text/plain, text/*"
    a = {"text/plain" => 1.0, "application/json" => 0.9999, "text/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("text/plain", t)
  end

  def test_full_only
    h = "application/xml"
    a = {"application/json" => 1.0, "text/html" => 0.9999, "application/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("application/xml", t)
  end

  def test_no_match
    h = "text/plain"
    a = {"application/json" => 1.0, "text/html" => 0.9999, "application/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal(nil, t)
  end

  def test_empty_header
    h = ""
    a = {"application/json" => 1.0, "text/html" => 0.9999, "application/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal(nil, t)
  end

  def test_nil_header
    h = nil
    a = {"application/json" => 1.0, "text/html" => 0.9999, "application/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("application/json", t)
  end

  def test_3levels
    h = "application/xml, application/json, text/plain; q=0.8, */*; q=0.5"
    a = {"text/plain" => 1.0, "application/xml" => 0.9999}
    t = Negotiator.pick(h, a)
    assert_equal("application/xml", t)
  end

  def test_browser
    h = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    a = {"application/json" => 1.0, "text/html" => 0.9999, "application/xml" => 0.9998}
    t = Negotiator.pick(h, a)
    assert_equal("text/html", t)
  end

  def test_general_markdown_preferred
    h = "audio/*; q=0.2, audio/basic"
    a = {"audio/mp3" => 1.0, "audio/basic" => 0.9999}
    t = Negotiator.pick(h, a)
    assert_equal("audio/basic", t)
  end

  def test_general_markdown_nonpreferred
    h = "audio/*; q=0.2, audio/basic"
    a = {"audio/mp3" => 1.0, "audio/basic" => 0.1}
    t = Negotiator.pick(h, a)
    assert_equal("audio/mp3", t)
  end

  def test_general_markup_preferred
    h = "audio/*; q=1.2, audio/basic"
    a = {"audio/mp3" => 1.0, "audio/basic" => 0.9999}
    t = Negotiator.pick(h, a)
    assert_equal("audio/mp3", t)
  end

  def test_general_markup_nonpreferred
    h = "audio/*; q=1.2, audio/basic"
    a = {"audio/mp3" => 1.0, "audio/basic" => 1.3}
    t = Negotiator.pick(h, a)
    assert_equal("audio/basic", t)
  end

  def test_specific_markdown_preferred
    h = "audio/*, audio/basic; q=0.2"
    a = {"audio/mp3" => 1.0, "audio/basic" => 0.9999}
    t = Negotiator.pick(h, a)
    assert_equal("audio/mp3", t)
  end

  def test_specific_markdown_nonpreferred
    h = "audio/*, audio/basic; q=0.2"
    a = {"audio/mp3" => 0.1, "audio/basic" => 1.0}
    t = Negotiator.pick(h, a)
    assert_equal("audio/basic", t)
  end

  def test_specific_markup_preferred
    h = "audio/*, audio/basic; q=1.2"
    a = {"audio/mp3" => 1.0, "audio/basic" => 0.9999}
    t = Negotiator.pick(h, a)
    assert_equal("audio/basic", t)
  end

  def test_specific_markup_nonpreferred
    h = "audio/*, audio/basic; q=1.2"
    a = {"audio/mp3" => 1.3, "audio/basic" => 1.0}
    t = Negotiator.pick(h, a)
    assert_equal("audio/mp3", t)
  end
end
