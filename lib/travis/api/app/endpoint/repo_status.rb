require 'travis/api/app'

class Travis::Api::App
  class Endpoint
    class RepoStatus < Endpoint
      register :format

      before do
        halt 401 if private_mode? && !org? && !authenticated?
      end

      set :pattern, capture: { id: /\d+/ }

      get '/:id/cc', format: :xml, scope: [:public, :travis_token] do
        repo = service(:find_repo, params).run
        halt 404 unless repo
        Responders::Xml.new(self, repo).apply
      end

      get '/:owner_name', format: :xml, scope: [:public, :travis_token] do
        respond_with service(:find_repos, params.merge(schema: 'cc')), responder: :xml
        repos = service(:find_repos, params).run
        Responders::Xml.new(self, repos).apply
      end

      get '/:owner_name/:name', format: :png, scope: [:public, :travis_token] do
        repo = service(:find_repo, params).run
        Responders::Image.new(self, repo).apply
      end

      get '/:owner_name/:name', format: :svg, scope: [:public, :travis_token] do
        repo = service(:find_repo, params).run
        Responders::Badge.new(self, repo).apply
      end

      get '/:owner_name/:name', format: :xml, scope: [:public, :travis_token] do
        repo = service(:find_repo, params).run
        halt 404 unless repo
        Responders::Xml.new(self, repo).apply
      end

      get '/:owner_name/:name/builds', format: :atom, scope: [:public, :travis_token] do
        builds = service(:find_builds, params).run
        halt 406 unless builds.any?
        Responders::Atom.new(self, builds).apply
      end

      get '/:owner_name/:name/cc', format: :xml, scope: [:public, :travis_token] do
        repo = service(:find_repo, params).run
        halt 404 unless repo
        Responders::Xml.new(self, repo).apply
      end
    end
  end
end
