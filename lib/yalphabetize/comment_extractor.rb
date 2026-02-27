module Yalphabetize
  class CommentExtractor
    def initialize(yaml)
      @lines = yaml.lines.to_a
      @last = [0, 0]
      @bullet_owner = nil
    end

    def sublines(sl, sc, el, ec)
      if el < sl
        ""
      elsif el == sl
        (@lines[sl] || "")[sc...ec]
      else
        (@lines[sl] || "")[sc...] +
          @lines[sl + 1...el].join("") +
          (@lines[el] || "")[...ec]
      end
    end

    def char_at(l, c)
      (@lines[l] || "")[c]
    end

    def read_comments(line, column)
      s = sublines(*@last, line, column)
      @last = [line, column]
      comments = []
      s.scan(/-|#.*?$/) do |token|
        case token
        when "-"
          if @bullet_owner
            @bullet_owner.leading_comments.push(*comments)
            comments = []
          end
        else
          comments << token
        end
      end
      @bullet_owner = nil
      comments
    end

    def visit(node)
      case node
      when Psych::Nodes::Sequence, Psych::Nodes::Mapping
        has_delim = /[\[{]/.match?(char_at(node.start_line, node.start_column))
        has_bullet = node.is_a?(Psych::Nodes::Sequence) && !has_delim
        # Special-case on `- #foo\n  bar: baz`
        node.leading_comments.push(*read_comments(node.start_line, node.start_column)) if has_delim
        node.children.each do |subnode|
          @bullet_owner = subnode if has_bullet
          visit(subnode)
        end
        if has_delim
          target = node.children[-1] || node
          target.trailing_comments.push(*read_comments(node.end_line, node.end_column))
        end
      else
        raise TypeError
      end
    end

    def start_document(node)
      if !node.implicit
        node.leading_comments.push(*read_comments(node.start_line, node.start_column))
      end
    end

    def end_document(node)
      if !node.implicit_end
        node.root.trailing_comments.push(*read_comments(node.end_line, node.end_column))
      end
    end

    def start_stream(node);end

    def end_stream(node)
      target = node.children[-1] || node
      target.trailing_comments.push(*read_comments(node.end_line, node.end_column))
    end

    def start_mapping(node)
      #
    end

    def end_mapping(node)
      #
    end

    def scalar(node)
      node.leading_comments.push(*read_comments(node.start_line, node.start_column))
      @last = [node.end_line, node.end_column]
    end

    def alias(node)
      node.leading_comments.push(*read_comments(node.start_line, node.start_column))
      @last = [node.end_line, node.end_column]
    end

    def start_sequence(node)
      #
    end

    def end_sequence(node)
      #
    end
  end
end
