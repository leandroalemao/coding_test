class JobQueueParser
  attr_reader :jobs_queue

  def initialize(jobs_queue)
    @jobs_queue = jobs_queue
  end

  def parse
    jobs_queue.split("\n").inject({}){ |parsed_jobs, job|
      job = Job.new(*job.split('=>').map(&:strip).reject(&:empty?))
      parsed_jobs[job.name] = job
      parsed_jobs
    }
  end
end
