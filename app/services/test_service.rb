class TestService

  def initialize
    @myJoe = Member.first
  end

  def joe
    @myJoe
  end
end