# Inspired by ERB::Compiler (https://github.com/ruby/erb/blob/b58b188028fbb403f75d48d62717373fc0908f7a/lib/erb.rb)

module Yalphabetize
  class ErbCompiler
    DEFAULT_STAGS = %w(<%% <%= <%# <% %{).freeze
    DEFAULT_ETAGS = %w(%%> %> }).freeze

    class Scanner
      STAG_REG = /(.*?)(#{DEFAULT_STAGS.join('|')}|\z)/m
      ETAG_REG = /(.*?)(#{DEFAULT_ETAGS.join('|')}|\z)/m

      def initialize(src)
        @src = src
        @stag = nil
      end

      def scan
        while !scanner.eos?
          scanner.scan(stag ? ETAG_REG : STAG_REG)
          yield(scanner[1])
          yield(scanner[2])
        end
      end

      attr_accessor :stag

      private

      attr_reader :src

      def scanner
        @_scanner ||= StringScanner.new(src)
      end
    end

    def initialize
      @buffer = []
      @content = []
    end

    def compile(s)
      scanner = Scanner.new(s.b)
      scanner.scan do |token|
        next if token.nil?
        next if token == ''

        if scanner.stag.nil?
          compile_stag(token, scanner)
        else
          compile_etag(token, scanner)
        end
      end
    end

    def compile_stag(stag, scanner)
      case stag
      when *DEFAULT_STAGS
        scanner.stag = stag
        buffer << stag
      end
    end

    def compile_etag(etag, scanner)
      case etag
      when *DEFAULT_ETAGS
        buffer << etag
        content << buffer.join
        self.buffer = []
        scanner.stag = nil
      else
        buffer << etag
      end
    end

    attr_reader :content

    private

    attr_accessor :buffer
  end
end
