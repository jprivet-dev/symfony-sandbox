<?php

namespace App\Tests\Integration\Repository;

use App\DataFixtures\PostFixtures;
use App\Repository\PostRepository;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class PostRepositoryTest extends KernelTestCase
{
    public const POSTS_ALL_COUNT = 28;
    private PostRepository $repository;

    protected function setUp(): void
    {
        static::bootKernel();
        $this->repository = static::getContainer()->get(PostRepository::class);
    }

    public function testSomething(): void
    {
        $this->assertCount(PostFixtures::getPhrasesCount(), $this->repository->findAll());
    }

    public function testFindLatest(): void
    {
        $latest = $this->repository->findLatest();
        $first = $latest[0];
        $last = $latest[count($latest) - 1];

        $this->assertCount(5, $latest);
        $this->assertSame('Lorem ipsum dolor sit amet consectetur adipiscing elit', $first->getTitle());
        $this->assertSame('In hac habitasse platea dictumst', $last->getTitle());
    }

    /**
     * @dataProvider getPages
     */
    public function testFindAllPaginate(int $page, int $postsCount, string $fistTitle, string $lastTitle): void
    {
        $postsPaginate = $this->repository->findAllPaginate($page);
        $posts = $postsPaginate->getItems();
        $first = $posts[0];
        $last = $posts[count($posts) - 1];

        $this->assertCount($postsCount, $posts);
        $this->assertSame($fistTitle, $first->getTitle());
        $this->assertSame($lastTitle, $last->getTitle());
    }

    public static function getPages(): \Generator
    {
        // $page, $postsCount, $fistTitle, $lastTitle
        yield 'Page 1' => [
            1,
            5,
            'Lorem ipsum dolor sit amet consectetur adipiscing elit',
            'In hac habitasse platea dictumst',
        ];
        yield 'Page 2' => [
            2,
            5,
            'Morbi tempus commodo mattis',
            'Urna nisl sollicitudin id varius orci quam id turpis',
        ];
        yield 'Page 6' => [
            6,
            3,
            'Sunt seculaes transferre talis camerarius fluctuies',
            'Sunt torquises imitari velox mirabilis medicinaes',
        ];
    }
}
