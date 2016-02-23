require "minitest/autorun"

require "./lib/jdbc-url.rb"

class TestMeme < Minitest::Test
  def test_pg_url
    assert_equal JdbcUrl.from("postgres://abc:123@foo:5432/baz?ssl=true"),
      "jdbc:postgresql://foo:5432/baz?ssl=true&user=abc&password=123&sslmode=require"
  end
end
