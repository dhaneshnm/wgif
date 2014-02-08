require 'rspec'
require 'wgif/video'

describe WGif::Video do

  it 'has a name and filepath' do
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
    video.name.should eq("penguin")
    video.clip.path.should eq("spec/fixtures/penguin.mp4")
  end

  it 'sets up a logger' do
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
    video.logger.instance_variable_get(:@logdev).filename.should eq("/tmp/wgif/penguin.log")
  end

  it 'redirects FFMPEG log output to a file' do
    expect(FFMPEG).to receive(:logger=).with(an_instance_of(Logger))
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
  end

  it 'is trimmable' do
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
    video = video.trim("00:00:00", "00:00:05")
    video.clip.duration.should eq(5.02)
  end

  it 'returns its frames' do
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
    video = video.trim("00:00:00", "00:00:01")
    frames = video.to_frames
    frames.count.should eq(24)
  end

  it 'returns a specific number of frames' do
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
    video = video.trim("00:00:00", "00:00:01")
    frames = video.to_frames(frames: 10)
    frames.count.should eq(10)
  end
end