require 'spec_helper'

describe "Reports" do
  it "GETs /reports" do
    cred = basic_auth("joe_smith")
    get "/reports", nil, {'HTTP_AUTHORIZATION' => cred}
    response.status.should be(200)
  end

  reps  = %w(BAMRU-roster.html BAMRU-roster.csv BAMRU-roster-smso.csv BAMRU-roster.vcf)
  reps += %w(BAMRU-full.pdf BAMRU-field.pdf BAMRU-CertExpiration.pdf)
  reps += %w(BAMRU-names.pdf BAMRU-wallet.pdf Paging-ResponseTimes.pdf)

  reps.each do |rep|
    it "GETs /reports/#{rep}" do
      cred = basic_auth("joe_smith")
      get "/reports/#{rep}", nil, {'HTTP_AUTHORIZATION' => cred}
      response.status.should be(200)
    end
  end

end