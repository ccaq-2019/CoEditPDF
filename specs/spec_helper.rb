# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  CoEditPDF::Pdf.map(&:destroy)
  CoEditPDF::Account.map(&:destroy)
end

def auth_header(account_data)
  auth = CoEditPDF::AuthenticateAccount.call(
    name: account_data['name'],
    password: account_data['password']
  )

  "Bearer #{auth[:attributes][:auth_token]}"
end

DATA = {} # rubocop:disable Style/MutableConstant
DATA[:accounts] = YAML.safe_load File.read('app/db/seeds/accounts_seed.yml')
DATA[:pdfs] = YAML.safe_load File.read('app/db/seeds/pdfs_seed.yml')

## SSO fixtures
GH_ACCOUNT_RESPONSE = YAML.load(
  File.read('specs/fixtures/github_token_response.yml')
)
GOOD_GH_ACCESS_TOKEN = GH_ACCOUNT_RESPONSE.keys.first
SSO_ACCOUNT = YAML.load(File.read('specs/fixtures/sso_account.yml'))
