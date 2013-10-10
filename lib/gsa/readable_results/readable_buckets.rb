module GSA
  class ReadableBuckets < ReadableResults

    def self.parse(buckets)
      buckets = (buckets.select {|key, value| key == GSA::BUCKET})[GSA::BUCKET]
      parse_core(buckets) {|bucket| convert(bucket) }
    end

    def self.convert(bucket)
      bucket = Hash[*bucket] if bucket.is_a? Array
      {
        :bucket_value      => bucket[GSA::BUCKET_VALUE], 
        :bucket_low_range  => bucket[GSA::BUCKET_LOW_RANGE],
        :bucket_high_range => bucket[GSA::BUCKET_HIGH_RANGE],
        :bucket_count      => bucket[GSA::BUCKET_COUNT]
      }
    end
  end
end
