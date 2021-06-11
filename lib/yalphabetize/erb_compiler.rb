# frozen_string_literal: true

# Inspired by ERB::Compiler (https://github.com/ruby/erb/blob/b58b188028fbb403f75d48d62717373fc0908f7a/lib/erb.rb)

module Yalphabetize
  class ErbCompiler
    DEFAULT_STAGS = ['<%%', '<%=', '<%#', '<%', '%{'].freeze
    DEFAULT_ETAGS = ['%%>', '%>', '}'].freeze

    class Scanner
      STAG_REG = /(.*?)(#{DEFAULT_STAGS.join('|')}|\z)/m.freeze
      ETAG_REG = /(.*?)(#{DEFAULT_ETAGS.join('|')}|\z)/m.freeze

      def initialize(src)
        @src = src
        @stag = nil
      end

      def scan
        until scanner.eos?
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

    def compile(string)
      scanner = Scanner.new(string.b)
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
      buffer << etag

      case etag
      when *DEFAULT_ETAGS
        content << buffer.join
        self.buffer = []
        scanner.stag = nil
      end
    end

    attr_reader :content

    private

    attr_accessor :buffer
  end
end
