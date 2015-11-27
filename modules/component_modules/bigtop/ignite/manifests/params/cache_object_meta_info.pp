class ignite::params::cache_object_meta_info()
{
  $hash = {
    repo => {
      fields => {
        id => {
          'type' => 'long',
          descending_index => true
        },
        name => {
          'type' => 'string'
        },
        url => {
          'type' => 'string'
        }
      } 
    },
    actor => {
      fields => {
        avatar_url => {
          'type' => 'string'
        },
        gravatar_id => {
          'type' => 'string'
        },
        url => {
          'type' => 'string'
        },
        login => {
          'type' => 'string',
          query_field => true
        },
        id => {
          'type'  => 'long',
          ascending_index => true
        }	
      }	
    }
  }
}