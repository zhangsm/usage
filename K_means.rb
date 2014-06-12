#!/usr/bin/ruby
# autor: fuliang http://fuliang.iteye.com/
# http://fuliang.iteye.com/blog/891991

class RGB
    attr_accessor :r,:g,:b

    def initialize(r=0,g=0,b=0)
        @r,@g,@b = r,g,b
    end

    def +(rgb)
        @r += rgb.r
        @g += rgb.g
        @b += rgb.b
        self
    end

    def /(n)
        @r /= n
        @g /= n
        @b /= n
        self
    end
end

def random_k_centers(instances,k)
    rand_indxes = (0...instances.size).sort_by{rand}[0...k]
    instances.values_at(*rand_indxes)
end

def distance(ins1,ins2)#采用余弦值，因为255,255,255和200,200,200颜色基本类似
    dot_product = ins1.r * ins2.r + ins1.g * ins2.g + ins1.b * ins2.b
    mod1 = Math.sqrt(ins1.r * ins1.r + ins1.g * ins1.g + ins1.b * ins1.b)
    mod2 = Math.sqrt(ins2.r * ins2.r + ins2.g * ins2.g + ins2.b * ins2.b)
    return 1 - dot_product / (mod1 * mod2)
end

def k_means_cluster(instances,k,max_iter=100)
    random_centers = random_k_centers(instances,k)
    p random_centers
    instance_cluster_map = {}
    change_count = 0
    clusters = []
    0.upto(max_iter) do |iter_num|
        clusters = []
        puts "iterate #{iter_num} ..."
        change_count = 0
        # E-step
        instances.each do |instance|
            min_distance = 1.0/0
            min_indx = 0
            random_centers.each_with_index do |center,index|
                current_distance = distance(center,instance)
                if min_distance > current_distance then
                    min_indx = index
                    min_distance = current_distance
                end
            end
            if instance_cluster_map[instance] != min_indx then#trace the change
                change_count += 1
                instance_cluster_map[instance] = min_indx
            end
            clusters[min_indx] ||= []
            clusters[min_indx] << instance
        end
        puts "change_count=#{change_count}"
        break if change_count.zero?
        #M-step
        clusters.each_with_index do |cluster,index|
            center = RGB.new
            cluster.each do |instance|
                center += instance
            end
            center /= cluster.size
            random_centers[index] = center # update center
        end
    end
    return clusters
end

instances = []
File.open("rgbs.txt").each_line do |line|
    line.split(/\t/).each do | rgb |
        r,g,b = rgb.split(/,/).collect{|e| e.to_i}
        instances << RGB.new(r,g,b)
    end
end

clusters = k_means_cluster(instances,5,100)
k_candidates = []
clusters.each do |cluster|
    sum = cluster.inject(RGB.new) {|sum,ins| sum + ins}
    candidate = sum / cluster.size
    k_candidates << candidate
end

p k_candidates

