require 'spec_helper'

describe GSA do
  include Fixtures

  describe "#direct_feed" do

    context "with many records" do

      it "successfully posts to the gsa" do
        VCR.use_cassette("many_records") do
          results = GSA.direct_feed(
            :file_name => "out", :records => many_records, 
            :searchable => [:name, :description], 
            :datasource_name => "products"
          )
          results.should eq success_text
        end
      end
    end

    context "with a single record" do

      it "successfully posts to the gsa" do
        VCR.use_cassette("single_record") do
          results = GSA.direct_feed(
            :file_name => "out", 
            :records => one_records, 
            :searchable => [:name, :description], 
            :datasource_name => "products"
          )
          results.should eq success_text
        end
      end
    end
  end

  describe "#pretty_search" do

    context "with no filters" do

      context "with a query yielding many matches" do

        let(:query)       { many_query }
        let(:results_set) { many_results }

        it "returns many records" do
          VCR.use_cassette("many_results_no_filters") do
            results = GSA.pretty_search(query)
            results.count.should eq results_set.count
          end
        end

        it "returns results in the expected 'pretty' format" do
          VCR.use_cassette("many_results_no_filters") do
            results = GSA.pretty_search(query)
            results.should eq results_set
          end
        end
      end

      context "with a query yielding a single match" do

        let(:query)      { one_query }
        let(:result_set) { one_results }

        it "returns a single record" do
          VCR.use_cassette("single_result_no_filters") do
            results = GSA.pretty_search(query)
            results.count.should eq 1
          end
        end

        it "returns the single result in the expected 'pretty' format" do
          VCR.use_cassette("single_result_no_filters") do
            results = GSA.pretty_search(query)
            results.should eq result_set
          end
        end
      end

      context "with a query yielding no matches" do

        let(:query) { none_query }

        it "returns the no record flag" do
          VCR.use_cassette("no_result_no_filters") do
            results = GSA.pretty_search(query)
            results.should eq GSA::NO_RESULTS
          end
        end
      end
    end

    context "with filters" do

      context "with a query yielding many results" do

        let(:query)        { many_query }
        let(:results_set)  { many_results }
        let(:filter_name)  { "brand" }
        let(:filter_value) { "Philips" }
        let(:filters)      { "#{filter_name}:#{filter_value}" }

        it "returns less than the unfiltered results" do
          VCR.use_cassette("many_results_with_filters") do
            results = GSA.pretty_search(query, :filters => filters)
            results.count.should be < results_set.count
          end
        end

        it "should only contain results matched in the unfiltered results" do
          VCR.use_cassette("many_results_with_filters") do
            results = GSA.pretty_search(query, :filters => filters)

            filtered_results = []
            results_set.each {|result| 
              result[:metatags].each {|tag| 
                if tag[:meta_name] == filter_name && tag[:meta_value] == filter_value
                  filtered_results << result
                end
              }
            }

            result_uids   = GSA.uids_from_pretty_search(results)
            filtered_uids = GSA.uids_from_pretty_search(filtered_results)
            result_uids.should eq filtered_uids
          end
        end
      end

      context "with a query yielding a single result" do

        let(:query)          { many_query }
        let(:results_set)    { many_results }
        let(:filter_1_name)  { "brand" }
        let(:filter_1_value) { "Philips" }
        let(:filter_2_name)  { "material" }
        let(:filter_2_value) { "Brass" }
        let(:filters)        { "#{filter_1_name}:#{filter_1_value}.#{filter_2_name}:#{filter_2_value}" }

        it "returns a single filtered result" do
          VCR.use_cassette("single_result_with_filters") do
            results = GSA.pretty_search(query, :filters => filters)
            results.count.should eq 1
          end
        end

        it "returns a result with the expected matching filters" do
          VCR.use_cassette("single_result_with_filters") do
            results = GSA.pretty_search(query, :filters => filters)

            results.each.inject([]) {|flags, result| result[:metatags].each {|tag|
                flags << 1 if tag[:meta_name] == filter_1_name && tag[:meta_value] == filter_1_value
                flags << 1 if tag[:meta_name] == filter_2_name && tag[:meta_value] == filter_2_value
              }
              flags
            }.should eq [1, 1]
          end
        end
      end

      context "with a query yielding no results" do

        let(:query)   { many_query }
        let(:filters) { "brand:FooBar" }

        it "returns the no record flag" do
          VCR.use_cassette("no_result_with_filters") do
            results = GSA.pretty_search(query, :filters => filters)
            results.should eq GSA::NO_RESULTS
          end
        end
      end
    end
  end

  describe "#facet" do

    let(:results_set) { many_results }

    context "with multiple facets" do

      let(:facetables)    { many_facets }
      let(:facet_results) { many_facet_results }

      it "returns multiple facets in the expected form" do
        results = GSA.facet(results_set, facetables)
        results.should eq facet_results
      end
    end

    context "with a single facet" do

      let(:facetables)    { one_facets }
      let(:facet_results) { one_facet_results }

      it "returns a single facet in the expected form" do
        results = GSA.facet(results_set, facetables)
        results.should eq facet_results
      end
    end
  end

  describe "#uids_from_pretty_search" do

    context "with multiple records passed in" do

      let(:results_set) { many_results }
      let(:uids)        { many_uids }

      it "returns multiple uids" do
        results = GSA.uids_from_pretty_search(results_set)
        results.should eq uids
      end
    end

    context "with a single record passed in" do

      let(:results_set) { one_results }
      let(:uids)        { one_uids }

      it "returns a single uid" do
        results = GSA.uids_from_pretty_search(results_set)
        results.should eq uids
      end
    end
  end
end
