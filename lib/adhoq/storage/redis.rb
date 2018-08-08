module Adhoq
  module Storage
    class Redis
      attr_reader :identifier

      def initialize(redis, prefix = "", expire = 300)
        @redis = redis
        @identifier = @prefix = prefix
        @expire = expire
      end

      def store(suffix = nil, seed = Time.now, &block)
        Adhoq::Storage.with_new_identifier(suffix, seed) do |identifier|
          @redis.setex(@prefix + identifier, @expire, yield.read)
        end
      end

      def direct_download?
        false
      end

      def get(identifier)
        @redis.get(@prefix + identifier)
      end
    end
  end
end
