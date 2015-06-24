require 'sinatra'
require 'yaml'
require 'json'

get '/v1/getUserIp' do
    fn = File.dirname(File.expand_path(__FILE__)) + '/config/config.yaml'
    iplist = YAML.load_file(File.open(fn))
    ip = params['ip']

    userKey = params['user']
    if !iplist[userKey].nil?
        if iplist[userKey] != ip
            ip = iplist[userKey]
        end
    end

    puts ip

    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type :json
    { :ip => ip }.to_json
end

post '/v1/register' do
    fn = File.dirname(File.expand_path(__FILE__)) + '/config/config.yaml'
    iplist = YAML.load_file(File.open(fn))

    userKey= params['user']
    if !iplist.nil? 
        if iplist[userKey].nil?
            iplist[userKey] = params['ip']
        end
    else
        iplist = Hash.new
        iplist[userKey] = params['ip']
    end

    File.open(fn, 'w') { |f| f.write iplist.to_yaml}

    response.headers['Access-Control-Allow-Origin'] = '*'
    status 200
end

post '/v1/verify' do
    fn = File.dirname(File.expand_path(__FILE__)) + '/config/config.yaml'
    iplist = YAML.load_file(File.open(fn))

    userKey= params['user']
    ip = params['ip']

    if iplist[userKey] != ip
        iplist[userKey] = ip
        File.open(fn, 'w') { |f| f.write iplist.to_yaml}
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    status 200
end

