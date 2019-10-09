require 'test_helper'

# :nodoc:
describe QonsoleRails::QonsoleConfig do
  # Will read the test config from ./test/dummy/config/qonsole.json
  let(:qonfig) { QonsoleRails::QonsoleConfig.new({}) }

  it 'should read the default endpoint from the loaded configuration' do
    _(qonfig.default_endpoint).must_equal 'http://landregistry.data.gov.uk/landregistry/query'
  end

  it 'should read the example queries from the loaded configuration' do
    _(qonfig.queries.length).must_equal 2
    _(qonfig.queries[1]['name']).must_equal 'transactions in a postcode'
  end

  it 'should read the endpoints from the loaded configuration' do
    _(qonfig.endpoints.length).must_equal 2
  end

  it 'should read the prefixes from the loaded configuration' do
    _(qonfig.prefixes.keys).must_include 'rdf'
  end

  it 'should return the query extracted from the request parameters' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('q' => 'a_query')
    _(alt_qonfig.query).must_equal 'a_query'
  end

  it 'should return the output format extracted from the request parameters' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('output' => 'json')
    _(alt_qonfig.output_format).must_equal 'json'
  end

  it 'should return the endpoint extracted from the request parameters' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('url' => 'http://foo')
    _(alt_qonfig.given_endpoint).must_equal 'http://foo'
    _(alt_qonfig.endpoint).must_equal 'http://foo'
  end

  it 'should use the default endpoint if no URL is given in the request parameters' do
    _(qonfig.given_endpoint).must_be_nil
    _(qonfig.endpoint).must_equal 'http://landregistry.data.gov.uk/landregistry/query'
  end

  it 'should return an absolute URL for the endpoint if given a relative URL and a hostname' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new({ 'url' => '/foo' }, host: 'http://foo.com')
    _(alt_qonfig.endpoint).must_equal '/foo'
    _(alt_qonfig.absolute_endpoint).must_equal 'http://foo.com/foo'
  end

  it 'should not fail if given a relative URL and no hostname' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('url' => '/foo')
    _(alt_qonfig.absolute_endpoint).must_equal '/foo'
  end

  it 'should return true for valid endpoints' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('url' => 'http://lr-pres-dev.epimorphics.net/landregistry/query')
    _(alt_qonfig.valid_endpoint?).must_equal true
  end

  it 'should return false for invalid endpoints' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('url' => 'http://scamsters.com/scam')
    _(alt_qonfig.valid_endpoint?).must_equal false
  end

  it 'should return identity if no alternative endpoint alias is defined' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('url' => 'http://lr-pres-dev.epimorphics.net/landregistry/query')
    _(alt_qonfig.service_destination).must_equal('http://lr-pres-dev.epimorphics.net/landregistry/query')
  end

  it 'should return nil if a non-permitted URL is given' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new('url' => 'http://lr-pres-dev.epimorphics.not/landregistry/query')
    _(alt_qonfig.service_destination).must_be_nil
  end

  it 'should return the service alias if an alternative endpoint is configured' do
    alt_qonfig = QonsoleRails::QonsoleConfig.new(
      { 'url' => 'http://lr-pres-dev.epimorphics.net/landregistry/query' },
      config_file_name: 'qonsole-1.json'
    )
    _(alt_qonfig.service_destination).must_equal('http://internal.alias.net/landregistry/query')
  end
end
