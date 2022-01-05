# frozen_string_literal: true

class SvgSprite
  class SVG
    attr_reader :filepath, :name, :optimize, :stroke, :fill

    def initialize(filepath, name:, optimize:, stroke:, fill:)
      @name = name
      @filepath = filepath
      @optimize = optimize
      @stroke = stroke
      @fill = fill
    end

    def symbol
      @symbol ||= xml.css("svg").first.clone.tap do |node|
        node.name = "symbol"
        node.set_attribute :id, id

        process_stroke(node)
        process_fill(node)
      end
    end

    def width
      symbol[:width]
    end

    def height
      symbol[:height]
    end

    def id
      @id ||= [name, File.basename(filepath, ".*")].join("--")
    end

    private def xml
      @xml ||= begin
        contents = File.read(filepath)
        contents = SvgOptimizer.optimize(contents) if optimize
        Nokogiri::XML(contents)
      end
    end

    private def process_stroke(node)
      process_attribute(node, "stroke", stroke)
    end

    private def process_fill(node)
      process_attribute(node, "fill", fill)
    end

    private def process_attribute(symbol, attribute, value)
      return unless value

      symbol.css("[#{attribute}]").each do |node|
        if value == "current-color" && node[attribute] != "none"
          node.set_attribute(attribute, "currentColor")
        end

        if value == "remove" && node[attribute] != "none"
          node.remove_attribute(attribute)
        end
      end
    end
  end
end
