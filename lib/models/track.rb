# Handle persistence in neo4j
# Also querying
module Smoothie

  class Track

    # Sample : 146063305

    attr_reader :id
    attr_accessor :attributes

    # Neo4j index
    if $neo.get_schema_index('Track').empty?
      $neo.create_schema_index('Track', ['id'])
    end

    def self.from_soundcloud(soundcloud)
      new(soundcloud.id, 
        :title      => soundcloud.title,
        :artist     => soundcloud.user.username,
        :duration   => soundcloud.duration,
        :likers     => soundcloud.favoritings_count,
        :created_at => Time.parse(soundcloud.created_at).to_i
      )
    end

    def self.find(track_id)
      track = new(track_id)
      if track.node
        track.attributes = track.node['data'].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        track
      else
        nil
      end
    end

    def initialize(id, attributes = {})
      @id = id
      @attributes = attributes
      @node = nil
    end

    # Persisting
    def save
      if self.node.nil?
        node = $neo.create_node(attributes.merge(:id => id, :name => self.to_s))
        $neo.set_label(node, 'Track')
        @node = node
      else
        $neo.set_node_properties self.node, attributes.merge(:name => self.to_s)
      end
    end

    # Finder
    def node
      return @node if @node

      # TODO : better query maybe?
      res = $neo.execute_query("MATCH (t:Track) WHERE t.id = #{id} RETURN t")
      if res['data'].empty?
        @node = nil
      else
        @node = res['data'].first.first
      end

      @node
    end

    def add_users(users)
      users.each do |user|
        # Save it
        user.save

        # Add the relationship
        $neo.create_relationship('likes', user.node, node)
      end
    end

    def to_s
      s = "Track ##{id}"
      s += " : #{attributes[:artist]} - #{attributes[:title]}" unless attributes.empty?
      s
    end

  end

end