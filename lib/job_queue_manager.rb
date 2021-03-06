class JobQueueManager
  attr_reader :jobs_queue

  def initialize(jobs_queue)
    @jobs_queue = jobs_queue
  end

  def process_jobs_queue
    parse_jobs_queue
    sort_jobs_queue!
  end

  private

  def parse_jobs_queue
    @jobs_queue = JobQueueParser.new(jobs_queue).parse
  end

  def sort_jobs_queue!
    raise RuntimeError, "Jobs can't have circular dependencies" if has_cyclic_dependency?
    jobs_queue.values.inject([]) { |sorted_jobs, job|
      sorted_jobs << job.name unless sorted_jobs.include?(job.name)
      if job.dependency
        sorted_jobs.delete(job.dependency)
        sorted_jobs.insert(sorted_jobs.index(job.name), job.dependency)
      end
      sorted_jobs
    }
  end

  def has_cyclic_dependency?
    jobs_queue.each { |job_name, job|
      dependencies = []
      while(job = jobs_queue[job.dependency])
        return true if dependencies.include?(job.name)
        dependencies << job.name
      end
    }
    return false
  end
end
