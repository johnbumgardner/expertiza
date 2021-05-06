describe "HttpRequest" do
  it "cannot be instantiated" do
    expect { HttpRequest.new }.to raise_error(NoMethodError)
  end

  it "correctly identifies URLs" do
    expect(HttpRequest.valid_url?("http://www.google.com")).to be_truthy
    expect(HttpRequest.valid_url?("https://www.google.com")).to be_truthy
    expect(HttpRequest.valid_url?("https://www.google.com:80")).to be_truthy

    expect(HttpRequest.valid_url?("http://www.google.com/")).to be_truthy
    expect(HttpRequest.valid_url?("http://www.google.com?")).to be_truthy
    expect(HttpRequest.valid_url?("http://www.google.com?arg1=123&arg2=456")).to be_truthy
    expect(HttpRequest.valid_url?("http://www.google.com/arg1/123/arg2/456")).to be_truthy
  end

  describe '#get' do
    context 'when the limit is too small' do
     it 'returns an empty string' do
       expect(HttpRequest.get('url', 0)).to eq('')
     end
    end
    context 'when you call a valid url' do
      it 'a 200 OK response' do
        url = 'https://httpbin.org'
        expect(HttpRequest.get(url, 5).message).to eq('OK')
      end
    end
    context 'when you call a url that will redirect' do
      it 'a 302 redirect response' do
        url = 'https://httpbin.org/redirect-to?url=https%3A%2F%2Fwww.google.com'
        expect(HttpRequest.get(url, 5).message).to eq('OK')
      end
    end
  end
end
